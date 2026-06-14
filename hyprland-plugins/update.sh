#!/usr/bin/bash
set -euxo pipefail

# Plugin commit advancement is RELEASE-GATED — this script no longer chases
# hyprland-plugins `main` HEAD on its own.
#
# Why: hyprland-plugins main tracks hyprland's *git* API and routinely runs
# ahead of the latest stable Hyprland release. This COPR builds plugins
# against the stable hyprland-devel, so a main-HEAD commit that adapts to an
# unreleased hyprland refactor (e.g. src/state/MonitorState.hpp) fails to
# compile and leaves the prior 0.55.x-pinned rpm stranded (repoclosure break).
#
# Instead, ../hyprland/update.sh advances `commit0` in hyprland-plugins.spec
# to plugins main HEAD only when a new stable hyprland release is detected —
# at which point upstream plugins are expected to match the released API — and
# then drives the ordered rebuild (hyprland first, then plugins re-pin).
#
# To pull a plugin-only fix in between hyprland releases, bump `commit0`
# manually in hyprland-plugins.spec (and `bumpver`) after verifying it builds
# against the current stable hyprland.

exit 0
