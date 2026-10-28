#!/usr/bin/bash
set -eu

declare -A SUBDIR=(
  [aylurs-gtk-shell2]=astal/aylurs-gtk-shell2
  [hyprpanel]=astal/hyprpanel
  [hyprland]=hyprland-git
)

PKGS=(
  aquamarine aylurs-gtk-shell aylurs-gtk-shell2 cliphist glaze hyprcursor hyprgraphics
  hypridle hyprland hyprland-git hyprland-protocols hyprland-qt-support hyprland-qtutils
  hyprlang hyprlock hyprpanel hyprpolkitagent hyprtoolkit hyprutils hyprwayland-scanner
  hyprwire material-icons-fonts matugen nwg-look pyprland uwsm waybar-git xcur2png
  xdg-desktop-portal-hyprland
)

for p in "${PKGS[@]}"; do
  sub="${SUBDIR[$p]:-$p}"
  echo ">>> $p ($sub)"
  copr-cli edit-package-scm blacktau/hyprland --name "$p" --clone-url https://github.com/blacktau/hyprlandRPM.git --commit main --subdir "$sub" --type git --method rpkg
done
