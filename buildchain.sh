#!/usr/bin/bash
# Local mock build chain for the Hyprland core stack on Fedora 44.
# Builds SRPMs from each spec, then runs mock --chain so each package
# can see the previously built RPMs without manual --addrepo wiring.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRPMDIR="/tmp/hyprland-srpm"
RESULTDIR="/tmp/hyprland-mock"
CHROOT="fedora-44-x86_64"

# Dependency order. hyprland-git last; needs everything above.
PKGS=(
  hyprutils
  hyprlang
  hyprwayland-scanner
  hyprgraphics
  hyprwire
  aquamarine
  hyprtoolkit
  glaze
  hyprland-git
)

mkdir -p "$SRPMDIR" "$RESULTDIR"

SRPMS=()
for p in "${PKGS[@]}"; do
  spec="$ROOT/$p/$p.spec"
  [ -f "$spec" ] || { echo "missing $spec"; exit 1; }
  echo ">>> fetch sources: $p"
  ( cd "$ROOT/$p" && spectool -g -C . "$p.spec" )
  echo ">>> build srpm: $p"
  rpmbuild -bs \
    --define "_sourcedir $ROOT/$p" \
    --define "_specdir $ROOT/$p" \
    --define "_srcrpmdir $SRPMDIR" \
    "$spec"
  srpm=$(ls -t "$SRPMDIR"/"$p"-*.src.rpm | head -1)
  SRPMS+=("$srpm")
done

echo ">>> mock chain build (chroot=$CHROOT)"
mock -r "$CHROOT" --chain --localrepo "$RESULTDIR" "${SRPMS[@]}"

echo ">>> done. results in $RESULTDIR"
