#!/usr/bin/bash
set -euo pipefail

# Bump plain tagged-release packages to their latest upstream GitHub release.
#
# Covers every package whose spec carries a literal `Version:` and a GitHub
# `URL:`. Packages with their own update.sh (the git-snapshot ones: hyprland,
# hyprland-plugins, hyprland-contrib) are skipped -- those have bespoke
# commit/bumpver logic and ordering rules.
#
# Deliberately does NOT touch pinned sonames in %files (e.g.
# `%{_libdir}/libhyprutils.so.13`). Those are pinned so an upstream soname bump
# FAILS the build loudly instead of silently shipping a broken library; fix
# them by hand when a build fails on one.
#
# Nothing rebuilds on push: there is no GitHub webhook and no COPR
# webhook_rebuild on any package, so this script triggers builds itself.
#   - leaf package bumped  -> copr-cli build-package for that package
#   - core library bumped  -> dispatch mass-rebuild.yml, which rebuilds
#     everything in dependency tier order (a soname bump strands every
#     dependent until it is rebuilt against the new lib)

PROJECT=blacktau/hyprland
cd "$(dirname "$0")/.."

# Libraries other packages link against: a bump here needs the tiered rebuild.
core_libs=" hyprutils hyprlang hyprcursor hyprgraphics aquamarine hyprwire
            hyprwayland-scanner hyprland-protocols glaze hyprtoolkit "

# Never auto-bumped: glaze 8.x is a major bump under hyprland and
# hyprsysteminfo -- verify it builds by hand before moving it.
skip=" glaze "

bumped=()
core_bumped=0

# Unauthenticated the GitHub API allows 60 requests/hour, which this loop
# exhausts; CI passes GITHUB_TOKEN, locally `gh auth token` works.
auth=()
if [ -n "${GITHUB_TOKEN:-}" ]; then
    auth=(-H "Authorization: Bearer $GITHUB_TOKEN")
fi

for spec in */*.spec astal/*/*.spec; do
    [ -f "$spec" ] || continue
    dir="$(dirname "$spec")"
    pkg="$(basename "$spec" .spec)"

    [ -f "$dir/update.sh" ] && continue
    case "$skip" in *" $pkg "*) continue ;; esac

    cur="$(sed -n 's/^Version: *//p' "$spec" | head -1)"
    # Macro-driven versions (git snapshots, %{upstream_version}) aren't ours.
    case "$cur" in ''|*%*) continue ;; esac

    repo="$(sed -n 's#^URL: *https://github.com/\([^/]*/[^/]*\)/*$#\1#p' "$spec" | head -1)"
    [ -n "$repo" ] || continue

    # Repos with tags but no GitHub *releases* 404 here (uwsm, screeninfo);
    # so do rate-limit blips. Both mean "skip this package this run".
    tag="$(curl -sf "${auth[@]}" \
             "https://api.github.com/repos/$repo/releases/latest" \
             | jq -r '.tag_name // empty' || true)"
    [ -n "$tag" ] || continue
    new="${tag#v}"
    # Only plain numeric versions; anything else needs a human.
    case "$new" in ''|*[!0-9.]*) continue ;; esac

    ec=0; rpmdev-vercmp "$cur" "$new" >/dev/null || ec=$?
    [ "$ec" = 12 ] || continue   # 12 = upstream newer

    sed -i "/^Version:/s/$cur/$new/" "$spec"
    git commit -qm "$pkg: bump to $new" "$spec"
    echo ">>> $pkg: $cur -> $new"
    bumped+=("$pkg")
    case "$core_libs" in *" $pkg "*) core_bumped=1 ;; esac
done

if [ ${#bumped[@]} -eq 0 ]; then
    exit 0
fi
git push

if [ "$core_bumped" = 1 ]; then
    # Tiered rebuild of the whole project; core libs strand dependents.
    curl -sf -X POST \
        -H "Authorization: Bearer ${GITHUB_TOKEN:?need token to dispatch mass-rebuild}" \
        -H "Accept: application/vnd.github+json" \
        "https://api.github.com/repos/${GITHUB_REPOSITORY:-blacktau/hyprlandRPM}/actions/workflows/mass-rebuild.yml/dispatches" \
        -d '{"ref":"main"}'
    echo ">>> core library bumped; dispatched mass-rebuild"
    exit 0
fi

if [ ! -f "$HOME/.config/copr" ]; then
    echo "no ~/.config/copr token; bumps pushed but nothing rebuilt" >&2
    exit 0
fi

for pkg in "${bumped[@]}"; do
    copr-cli build-package --name "$pkg" --nowait "$PROJECT"
done
