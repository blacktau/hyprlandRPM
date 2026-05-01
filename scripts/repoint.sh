#!/usr/bin/bash
set -eu

declare -A SUBDIR=(
  [appmenu-glib-translator]=astal/appmenu-glib-translator
  [astal]=astal/astal
  [astal-gjs]=astal/astal-gjs
  [astal-gtk4]=astal/astal-gtk4
  [astal-io]=astal/astal-io
  [astal-libs]=astal/astal-libs
  [astal-lua]=astal/astal-lua
  [aylurs-gtk-shell2]=astal/aylurs-gtk-shell2
  [hyprpanel]=astal/hyprpanel
  [hyprland]=hyprland-git
  [hyprland-plugins-git]=hyprland-plugins
)

PKGS=(
  appmenu-glib-translator aquamarine astal astal-gjs astal-gtk4 astal-io astal-libs astal-lua
  aylurs-gtk-shell aylurs-gtk-shell2 cliphist eww-git glaze hellwal hyprcursor hyprdim hyprgraphics
  hypridle hyprland hyprland-autoname-workspaces hyprland-contrib hyprland-git hyprland-plugins
  hyprland-plugins-git hyprland-protocols hyprland-qt-support hyprland-qtutils hyprlang hyprlauncher
  hyprlock hyprnome hyprpanel hyprpaper hyprpicker hyprpolkitagent hyprpwcenter hyprqt6engine
  hyprshot hyprsunset hyprsysteminfo hyprtoolkit hyprutils hyprwayland-scanner hyprwire
  material-icons-fonts matugen mpvpaper nwg-clipman nwg-look pyprland python-imageio-ffmpeg
  python-screeninfo satty swaylock-effects swww uwsm waybar-git waypaper xcur2png
  xdg-desktop-portal-hyprland
)

for p in "${PKGS[@]}"; do
  sub="${SUBDIR[$p]:-$p}"
  echo ">>> $p ($sub)"
  copr-cli edit-package-scm blacktau/hyprland --name "$p" --clone-url https://github.com/blacktau/hyprlandRPM.git --commit main --subdir "$sub" --type git --method rpkg
done
