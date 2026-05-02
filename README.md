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

## Packages

A collection of Hyprland and related packages:

* **[hyprland](https://wiki.hyprland.org/)** – A highly customizable dynamic tiling Wayland compositor that doesn't sacrifice on its looks.
* **[xdg-desktop-portal-hyprland](https://wiki.hyprland.org/Useful-Utilities/Hyprland-desktop-portal/)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/xdg-desktop-portal-hyprland/xdg-desktop-portal-hyprland.spec) – xdg-desktop-portal backend for hyprland.
* **hyprland-git** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/hyprland-git/hyprland-git.spec) – Hyprland git snapshots.
* **[hyprland-contrib](https://github.com/hyprwm/contrib)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/hyprland-contrib/hyprland-contrib.spec) – Community scripts and utilities for Hypr projects.
* **[hyprland-plugins](https://github.com/hyprwm/hyprland-plugins)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/hyprland-plugins/hyprland-plugins.spec) – Official [plugins](https://wiki.hyprland.org/Plugins/Using-Plugins/) for the hyprland package. (Installed in /usr/lib64/hyprland)
* **hyprland-plugins-git** – Official [plugins](https://wiki.hyprland.org/Plugins/Using-Plugins/) for the hyprland-git package. (Installed in /usr/lib64/hyprland)
* **[hyprpaper](https://github.com/hyprwm/hyprpaper)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/hyprpaper/hyprpaper.spec) – A blazing fast wayland [wallpaper](https://wiki.hyprland.org/hyprland-wiki/pages/Useful-Utilities/Wallpapers/) utility with IPC controls.
* **[hyprpicker](https://github.com/hyprwm/hyprpicker)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/hyprpicker/hyprpaper.spec) – A wlroots-compatible Wayland color picker.
* **[hypridle](https://github.com/hyprwm/hypridle)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/hypridle/hypridle.spec) - Hyprland's idle daemon.
* **[hyprlock](https://github.com/hyprwm/hyprlock)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/hyprlock/hyprlock.spec) - Hyprland's GPU-accelerated screen locking utility.
* **[hyprsunset](https://github.com/hyprwm/hyprsunset)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/hyprsunset/hyprsunset.spec) - An application to enable a blue-light filter on Hyprland.
* **[hyprpolkitagent](https://github.com/hyprwm/hyprpolkitagent)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/hyprpolkitagent/hyprpolkitagent.spec) - A simple polkit authentication agent for Hyprland.
* **[hyprsysteminfo](https://github.com/hyprwm/hyprsysteminfo)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/hyprsysteminfo/hyprsysteminfo.spec) - An application to display information about the running system.
* **[hyprland-autoname-workspaces](https://github.com/hyprland-community/hyprland-autoname-workspaces)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/hyprland-autoname-workspaces/hyprland-autoname-workspaces.spec) – Automatically rename workspaces with icons of started applications.
* **[hyprshot](https://github.com/Gustash/Hyprshot)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/hyprshot/hyprshot.spec) – A utility to easily take screenshots in Hyprland using your mouse.
* **[satty](https://github.com/gabm/Satty)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/satty/satty.spec) – A screenshot annotation tool inspired by Swappy and Flameshot.
* **[aylurs-gtk-shell](https://github.com/Aylur/ags)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/aylurs-gtk-shell/aylurs-gtk-shell.spec) - Aylurs's Gtk Shell (AGS), An eww inspired gtk widget system (legacy version).
* **[aylurs-gtk-shell2](https://github.com/Aylur/ags)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/astal/aylurs-gtk-shell2/aylurs-gtk-shell2.spec) - CLI around [Astal](https://github.com/aylur/astal) to scaffold and run projects.
* **[hyprpanel](https://hyprpanel.com/)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/astal/hyprpanel/hyprpanel.spec) - A Bar/Panel for Hyprland with extensive customizability.
* **[waybar-git](https://github.com/Alexays/Waybar)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/waybar-git/waybar-git.spec) – waybar git snapshots.
* **[eww-git](https://elkowar.github.io/eww/eww.html)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/eww-git/eww-git.spec) – A widget system made in Rust (git snapshots).
* **[nwg-clipman](https://github.com/nwg-piotr/nwg-clipman)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/nwg-clipman/nwg-clipman.spec) - GTK3-based GUI for cliphist.
* **[swww](https://github.com/Horus645/swww)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/swww/swww.spec) – Efficient animated wallpaper daemon for wayland, controlled at runtime.
* **[waypaper](https://github.com/anufrievroman/waypaper)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/waypaper/waypaper.spec) - GUI wallpaper manager.
* **[hyprnome](https://github.com/donovanglover/hyprnome)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/hyprnome/hyprnome.spec) – GNOME-like workspace switching in Hyprland.
* **[hyprdim](https://github.com/donovanglover/hyprdim)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/hyprdim/hyprdim.spec) – Automatically dim windows in Hyprland when switching between them.
* **[swaylock-effects](https://github.com/jirutka/swaylock-effects)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/swaylock-effects/swaylock-effects.spec) - Swaylock, with fancy effects.
* **[pyprland](https://github.com/hyprland-community/pyprland)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/pyprland/pyprland.spec) - Hyprland extensions.
* **[mpvpaper](https://github.com/GhostNaN/mpvpaper)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/mpvpaper/mpvpaper.spec) - A video wallpaper program for wlroots based wayland compositors.
* **[uwsm](https://github.com/Vladimir-csp/uwsm)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/uwsm/uwsm.spec) - Universal Wayland Session Manager.
* **[qt6ct-kde](https://github.com/ilya-fedin/qt6ct)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/qt6ct-kde/qt6ct.spec) - Qt6 Configuration Utility, patched for proper integration with KDE applications.
* **[hyprqt6engine](https://github.com/hyprwm/hyprqt6engine)** [(spec)](https://github.com/blacktau/hyprlandRPM/blob/main/hyprqt6engine/hyprqt6engine.spec) - Qt6 Theme Provider for Hyprland.

## Prerequisites (not built here)

Some tools commonly used with Hyprland are not packaged in this COPR. Install separately.

### cliphist — Wayland clipboard manager

Removed from this fork because vendored Go dependencies (`vendor-*.tar.gz`) are not redistributable through the spec. Install via Go:

```
go install go.senan.xyz/cliphist@latest
```

Or grab a release binary: https://github.com/sentriz/cliphist/releases

The `nwg-clipman` GUI (still built here) works against an upstream-installed `cliphist` binary.

## Issues

Open at: https://github.com/blacktau/hyprlandRPM/issues
