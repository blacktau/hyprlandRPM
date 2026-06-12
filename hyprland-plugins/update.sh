#!/usr/bin/bash
set -euxo pipefail

# Track the hyprland-plugins upstream commit. Bumps bumpver and rebuilds (via
# the COPR SCM webhook on push) only when the upstream commit actually changes.
#
# NOTE: a hyprland *version* bump (without a plugins commit change) is handled
# by ../hyprland/update.sh, which bumps bumpver here and drives an ordered
# rebuild so plugins re-pin the new `hyprland = <ver>`.

SPEC=hyprland-plugins.spec

oldCommit="$(sed -n 's/.*\bcommit0\b \(.*\)/\1/p' $SPEC)"
newCommit="$(curl -s -H "Accept: application/vnd.github.VERSION.sha" \
              "https://api.github.com/repos/hyprwm/hyprland-plugins/commits/main")"

sed -i "s/$oldCommit/$newCommit/" $SPEC

git diff --quiet || \
{ perl -pe 's/(?<=bumpver\s)(\d+)/$1 + 1/ge' -i $SPEC && \
git commit -am "up rev hyprland-plugins-${newCommit:0:7}" && \
git push; }
