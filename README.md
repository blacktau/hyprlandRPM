# blacktau/hyprland COPR

Fork of `solopasha/hyprland` rebuilt for Fedora 44+ against current upstream library versions (libdisplay-info 0.3, hyprgraphics 0.4, etc.).

## Enable

```
sudo dnf copr enable blacktau/hyprland
sudo dnf install hyprland
```

## Version notes

- 0.49.0 → last version for Fedora 41
- 0.51.0 → likely the last version for Fedora 42 (as of 2025-09-15, hyprland-git fails to build on F42)
- 0.51.0+ → requires Fedora 43+
- Current builds target Fedora 44

## Packages built here

Hyprland core + ecosystem pieces not in Fedora main, or where Fedora ships too old:

* **[hyprland](https://wiki.hyprland.org/)** – A highly customizable dynamic tiling Wayland compositor.
* **[xdg-desktop-portal-hyprland](https://wiki.hyprland.org/Useful-Utilities/Hyprland-desktop-portal/)** – xdg-desktop-portal backend for hyprland.
* **hyprland-git** – Hyprland git snapshots.
* **[hyprland-contrib](https://github.com/hyprwm/contrib)** – Community scripts and utilities for Hypr projects.
* **[hyprland-plugins](https://github.com/hyprwm/hyprland-plugins)** – Official plugins for hyprland.
* **hyprland-plugins-git** – Plugins for hyprland-git.
* **[hyprpaper](https://github.com/hyprwm/hyprpaper)** – Wayland wallpaper utility with IPC controls.
* **[hyprpicker](https://github.com/hyprwm/hyprpicker)** – wlroots-compatible Wayland color picker.
* **[hypridle](https://github.com/hyprwm/hypridle)** – Hyprland's idle daemon.
* **[hyprlock](https://github.com/hyprwm/hyprlock)** – Hyprland's GPU-accelerated screen locker.
* **[hyprsunset](https://github.com/hyprwm/hyprsunset)** – Blue-light filter for Hyprland.
* **[hyprpolkitagent](https://github.com/hyprwm/hyprpolkitagent)** – Polkit auth agent for Hyprland.
* **[hyprsysteminfo](https://github.com/hyprwm/hyprsysteminfo)** – System info display app.
* **[hyprland-autoname-workspaces](https://github.com/hyprland-community/hyprland-autoname-workspaces)** – Auto-rename workspaces with app icons.
* **[hyprshot](https://github.com/Gustash/Hyprshot)** – Screenshot utility for Hyprland.
* **[satty](https://github.com/gabm/Satty)** – Screenshot annotation tool.
* **[hyprpanel](https://hyprpanel.com/)** – Customizable Bar/Panel for Hyprland.
* **[eww-git](https://elkowar.github.io/eww/eww.html)** – Rust widget system (git snapshots).
* **[nwg-clipman](https://github.com/nwg-piotr/nwg-clipman)** – GTK3 GUI for cliphist.
* **[swww](https://github.com/Horus645/swww)** – Animated wallpaper daemon.
* **[waypaper](https://github.com/anufrievroman/waypaper)** – GUI wallpaper manager.
* **[hyprnome](https://github.com/donovanglover/hyprnome)** – GNOME-like workspace switching.
* **[hyprdim](https://github.com/donovanglover/hyprdim)** – Auto-dim inactive windows.
* **[swaylock-effects](https://github.com/jirutka/swaylock-effects)** – Swaylock with effects.
* **[mpvpaper](https://github.com/GhostNaN/mpvpaper)** – Video wallpaper.
* **[uwsm](https://github.com/Vladimir-csp/uwsm)** – Universal Wayland Session Manager.
* **[qt6ct-kde](https://github.com/ilya-fedin/qt6ct)** – Qt6 config util, patched for KDE integration.
* **[hyprqt6engine](https://github.com/hyprwm/hyprqt6engine)** – Qt6 theme provider for Hyprland.
* **hyprutils, hyprlang, hyprcursor, hyprgraphics, aquamarine, hyprwayland-scanner, hyprland-qt-support, hyprland-qtutils, hyprtoolkit, hyprwire, glaze, hellwal, hyprpwcenter, hyprlauncher, python-imageio-ffmpeg, python-screeninfo** – libs and helpers needed by the above (Fedora ships older versions).

## Prerequisites — install from Fedora main

These packages are available in Fedora main repos with equal or newer versions. Install via dnf:

```
sudo dnf install \
  kitty \
  waybar \
  matugen \
  pyprland \
  nwg-look \
  aylurs-gtk-shell \
  material-icons-fonts \
  xcur2png
```

## Prerequisites — install separately

### cliphist — Wayland clipboard manager

Removed from this fork: vendored Go deps tarball is not practical to redistribute via the spec. Install via Go:

```
go install go.senan.xyz/cliphist@latest
```

Or grab a release binary: https://github.com/sentriz/cliphist/releases

The `nwg-clipman` GUI (built here) works against an upstream-installed `cliphist` binary.

## Issues

Open at: https://github.com/blacktau/hyprlandRPM/issues
