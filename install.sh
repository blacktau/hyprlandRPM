#!/usr/bin/env bash
# Install Hyprland + ecosystem on Fedora 44+.
# Mirrors what /storage/external/Fedora-Hyprland sets up, but pulls
# Hyprland core from blacktau/hyprland COPR instead of solopasha.
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "Run as a normal user; sudo is invoked where needed."
  exit 1
fi

# ---------- COPR repos ----------
COPR_REPOS=(
  blacktau/hyprland
  erikreider/SwayNotificationCenter
)

# ---------- RPM Fusion ----------
sudo dnf install -y \
  "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
  "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

# ---------- Enable COPRs ----------
for repo in "${COPR_REPOS[@]}"; do
  sudo dnf copr enable -y "$repo"
done

sudo dnf update -y

# ---------- Hyprland core (from blacktau/hyprland) ----------
HYPRLAND_CORE=(
  hyprland
  hypridle
  hyprlock
  hyprsunset
  hyprpaper
  hyprpicker
  hyprshot
  hyprpolkitagent
  hyprsysteminfo
  hyprland-plugins
  hyprland-contrib
  hyprland-autoname-workspaces
  hyprdim
  hyprnome
  hyprlauncher
  hyprtoolkit
  hyprwire
  hyprqt6engine
  hyprland-qt-support
  hyprland-qtutils
  hyprpwcenter
  xdg-desktop-portal-hyprland
  nwg-clipman
  swww
  swaylock-effects
  satty
  eww-git
  uwsm
  mpvpaper
  waypaper
  qt6ct-kde
)

# ---------- From Fedora main repos ----------
FEDORA_MAIN=(
  # Core utilities used by typical configs
  bc curl findutils gawk git inxi jq nano openssl rsync unzip wget2
  xdg-user-dirs xdg-utils

  # Wayland tooling (formerly built in COPR; Fedora has these now)
  kitty waybar matugen pyprland nwg-look aylurs-gtk-shell
  material-icons-fonts xcur2png

  # Capture / clipboard
  grim slurp swappy wl-clipboard

  # Notification + launcher
  rofi wlogout

  # Audio / media
  pamixer pavucontrol pipewire-alsa pipewire-utils pulseaudio-utils playerctl

  # Network / Bluetooth / system
  network-manager-applet
  gvfs gvfs-mtp

  # Theming / Qt
  kvantum kvantum-qt5 qt5ct qt6ct qt6-qtsvg
  qt5-qtdeclarative qt5-qtquickcontrols2 qt6-qtdeclarative

  # Polkit + file picker
  xfce-polkit yad

  # Python helpers commonly referenced by configs
  python3-requests python3-pip python3-pyquery

  # Misc
  ImageMagick
)

# ---------- Optional extras (comment out anything you don't want) ----------
EXTRAS=(
  brightnessctl
  btop
  cava
  loupe
  fastfetch
  gnome-system-monitor
  mousepad
  mpv
  mpv-mpris
  nvtop
  qalculate-gtk
)

# ---------- From SwayNotificationCenter COPR ----------
SWAYNC=(
  SwayNotificationCenter
)

echo "==> Installing Hyprland core from blacktau/hyprland..."
sudo dnf install -y "${HYPRLAND_CORE[@]}"

echo "==> Installing Fedora main packages..."
sudo dnf install -y "${FEDORA_MAIN[@]}"

echo "==> Installing optional extras..."
sudo dnf install -y "${EXTRAS[@]}"

echo "==> Installing notification daemon..."
sudo dnf install -y "${SWAYNC[@]}"

# ---------- cliphist (not packaged here; install via Go) ----------
if ! command -v cliphist >/dev/null 2>&1; then
  echo "==> Installing cliphist via Go..."
  if ! command -v go >/dev/null 2>&1; then
    sudo dnf install -y golang
  fi
  go install go.senan.xyz/cliphist@latest
  echo "    cliphist installed to ~/go/bin/cliphist — ensure ~/go/bin is on PATH."
fi

echo
echo "Done. Reboot and select Hyprland from your display manager (or launch via uwsm)."
