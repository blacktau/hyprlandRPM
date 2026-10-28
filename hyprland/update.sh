#!/usr/bin/bash
set -euxo pipefail

# Auto-bump the release Hyprland package when upstream tags a new stable
# release, push, then trigger the COPR build ourselves (nothing rebuilds on
# push -- there is no COPR webhook).

PROJECT=blacktau/hyprland
SPEC=hyprland.spec

oldVer="$(rpmspec -q --qf '%{version}\n' $SPEC | head -1)"
# /releases/latest is the newest non-prerelease, non-draft release.
newVer="$(curl -s https://api.github.com/repos/hyprwm/Hyprland/releases/latest \
            | jq -r '.tag_name' | sed 's/^v//')"

ec=0
rpmdev-vercmp "$oldVer" "$newVer" || ec=$?
case $ec in
    0)  exit 0 ;;   # already current
    11) exit 0 ;;   # local newer than upstream (shouldn't happen) -> skip
    12) ;;          # upstream newer -> proceed
    *)  exit 1 ;;
esac

# --- bump hyprland ---
sed -i "/^Version:/s/$oldVer/$newVer/" $SPEC
git commit -am "hyprland: bump to v${newVer}"
git push

if [ ! -f "$HOME/.config/copr" ]; then
    echo "no ~/.config/copr token; skipping COPR build" >&2
    exit 0
fi

out="$(copr-cli build-package --name hyprland --nowait "$PROJECT")"
id="$(echo "$out" | sed -nE 's/^Created builds?: ([0-9]+).*/\1/p' | head -1)"
[ -n "$id" ] || { echo "could not parse build id for hyprland: $out" >&2; exit 1; }
echo ">>> hyprland -> build $id"
copr-cli watch-build "$id"
