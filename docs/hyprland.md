# Hyprland Configuration Structure Overview

The Hyprland setup in this NixOS configuration is located at `modules/desktop/hyprland` and is structured into a modular layout, utilizing `default.nix` as the core configuration and delegating specific components to their respective folders.

## Directory Structure

- `default.nix`: The main entry point module for Hyprland.
- `icons/`: Contains custom icons for notifications, volume, brightness, battery, etc.
- `programs/`: Contains individual configurations for desktop components (Waybar, Rofi, etc.).
- `scripts/`: Holds utility bash scripts that perform various system actions. 

---

### Core Configuration: `default.nix`

This file is a comprehensive Nix expression that configures the entire Hyprland ecosystem through Home Manager. It is responsible for:

- **Importing Sub-modules**: Bringing in configs from the `programs/` directory (e.g., Waybar, Rofi, Hypridle, SwayNC).
- 
- **Environment Setup**: Setting essential Wayland environment variables (like `XDG_SESSION_TYPE`, `GDK_BACKEND`, `MOZ_ENABLE_WAYLAND`, etc.).
- 
- **Autostart Services (`exec-once`)**: Launching essential services on startup (Polkit agent, network manager applet, clipboard history daemon, battery notifier, sunset tint, etc.).
- 
- **Hyprland Settings**: Defining the aesthetic and functional properties of the window manager, including:
- 
  - Input settings (keyboard layout, touchpad options).
  - General aesthetics (gaps, borders, master/dwindle layouts).
  - Decorations (blur, rounding, animations).
  - 
- **Window Rules**: Defining precise behaviors (floating, opacity, blur) for specific applications and games.
- 
- **Keybindings (`bind`, `binde`, `bindm`)**: Managing hotkeys to launch applications, manipulate windows, control workspaces, take screenshots, and manage media using scripts from the `scripts/` folder.
- 
- **Monitors & Workspaces**: Binding specific workspaces to designated monitors to maintain a stable multi-monitor setup.

### The `programs/` Directory

This directory acts as a registry for individual components and applications that integrate with the Hyprland setup. Each component has its own subdirectory containing its respective `.nix` configuration.

Current programs include:

- `ags`: Aylur's GTK Shell (for customizable widgets).
- `awww`: Animated wallpaper daemon or wrapper.
- `dunst` (currently disabled in `default.nix`): Lightweight notification daemon.
- `hypridle`: Idle management daemon (auto-lock, screen off).
- `hyprlock`: Lock screen interface.
- `hyprpanel`: A panel alternative for Hyprland.
- `rofi`: The application launcher, menu, and clipboard interface.
- `swaylock`: Alternative screen locker for Wayland.
- `swaync`: SwayNotificationCenter, an advanced notification daemon with a control center.
- `waybar`: The main status bar.
- `wlogout`: A Wayland-based logout menu.

### The `scripts/` Directory

This folder is populated with utility scripts used heavily by the keybindings defined in `default.nix`. Some of the most notable scripts include:

- **Media & System Control**: `MediaCtrl.sh`, `volumecontrol.sh`, `brightnesscontrol.sh`.
- 
- **System Information**: `gpuinfo.sh`, `cpu_temp.sh`, `weather.sh`.
- 
- **Tools**: `screenshot.sh` (utilizing grim/slurp/swappy), `batterynotify.sh` (to alert on low battery), `keyboardswitch.sh`.
- 
- **Game/Power Modes**: `gamemode.sh`, `TogglePowerMode.sh`.
- 
- **UI Integrations**: `rofimusic.sh`, `ClipManager.sh` (integrating rofi with cliphist).

### The `icons/` Directory
A collection of `.png` and `.svg` files that provide customized visual assets for UI elements. These include:

- Status indicators (e.g., `volume-high.png`, `brightness-80.png`, `battery-status.png`).
- 
- Specific widget icons (`music.png`, `weather.sh` dependencies).
- 
- A sub-folder `notifications/` for categorized alert icons.
