#!/usr/bin/bash
set -euxo pipefail

# Auto-bump the release Hyprland package when upstream tags a new stable
# release, then drive an ORDERED COPR rebuild:
#   1. build hyprland (publishes hyprland-devel = <newver>)
#   2. once that succeeds, bump+rebuild hyprland-plugins
#
# Ordering matters: hyprland-plugins hard-requires `hyprland = <exact ver>`
# (captured at build time from hyprland-devel). If plugins build before the
# new hyprland-devel lands they re-pin the OLD version, leaving users unable
# to upgrade hyprland (dnf: "requires hyprland = <old>, but none of the
# providers can be installed"). It is the ONLY package that pins exact.

PROJECT=blacktau/hyprland
SPEC=hyprland.spec
PLUGINS_DIR=../hyprland-plugins
PLUGINS_SPEC=hyprland-plugins.spec

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

# Without a COPR API token we can't order builds; the SCM webhook will rebuild
# both packages unordered (plugins may re-pin the old version). Still push the
# version bump so a human/mass-rebuild can finish the job.
if [ ! -f "$HOME/.config/copr" ]; then
    echo "no ~/.config/copr token; skipping ordered rebuild" >&2
    exit 0
fi

build_and_watch() {
    local pkg=$1 out id
    out="$(copr-cli build-package --name "$pkg" --nowait "$PROJECT")"
    id="$(echo "$out" | sed -nE 's/^Created builds?: ([0-9]+).*/\1/p' | head -1)"
    [ -n "$id" ] || { echo "could not parse build id for $pkg: $out" >&2; return 1; }
    echo ">>> $pkg -> build $id"
    copr-cli watch-build "$id"
}

# 1. hyprland (provides hyprland-devel = newVer)
build_and_watch hyprland

# 2. plugins: advance to the plugins commit matching this hyprland release,
#    then bump bumpver so the NVR changes, and rebuild against the new
#    hyprland-devel now in the repo (so plugins re-pin `hyprland = newVer`).
#
#    hyprland-plugins/update.sh no longer chases main HEAD on its own because
#    plugins main routinely runs ahead of the stable hyprland API. A new stable
#    release is the point at which upstream plugins are expected to match, so
#    we advance commit0 to plugins main HEAD HERE, gated on the release.
pluginsCommit="$(curl -s -H "Accept: application/vnd.github.VERSION.sha" \
                  https://api.github.com/repos/hyprwm/hyprland-plugins/commits/main)"
( cd "$PLUGINS_DIR" \
  && sed -i "s/^\(%global commit0\) .*/\1 ${pluginsCommit}/" "$PLUGINS_SPEC" \
  && perl -pe 's/(?<=bumpver\s)(\d+)/$1 + 1/ge' -i "$PLUGINS_SPEC" )
git commit -am "hyprland-plugins: ${pluginsCommit:0:7} + rebuild for hyprland v${newVer}"
git push
build_and_watch hyprland-plugins
