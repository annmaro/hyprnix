# Niri Configuration Structure Overview

Niri is a highly customisable, scrollable-tiling window manager/compositor for Wayland. In this NixOS configuration, the entire desktop setup is consolidated within the modular directory at `modules/desktop/niri`. 

This documentation explains how the Niri ecosystem is organized, how its components interact, and details the specific native KDL configuration structure that orchestrates the desktop environment.

---

## Modular Directory Structure

The `modules/desktop/niri` configuration is divided into highly-specialized components to ensure clean modularity and easy styling overrides:

- **`default.nix`**: The main entry point. It sets system-wide variables, enables binary caches, sets the default session, installs system-wide packages, defines GNOME/GTK portal overrides, and hosts the native KDL configurations via Home Manager.
- **`dms/`**: Orchestrates the **Dank Material Shell (DMS)** framework. See the dedicated [dms.md](dms.html) documentation for full details on enabled features, integration settings, and styling patches.
- **`rofi/`**: Installs and customizes **Rofi** to serve as the application launcher, clipboard history UI, and emoji menu.
- **`stylix/`**: Manages global look-and-feel across all toolkit contexts dynamically. It enforces base16 color schemes, dark mode databases, Bibata cursors, and applies custom compact CSS to GTK/Thunar interfaces.
- **`swaylock/`**: Configures the screen locker, integrating closely with the overall color scheme.
- **`scripts/`**: Contains numerous utility scripts (e.g., `gamemode.nix`, `wallpaper.nix`, `clipmanager.nix`, `screen-record.nix`) that are wrapped into standalone commands and bound to Niri hotkeys.

---

## Core Configuration: `default.nix`

`default.nix` is the heart of the Niri setup. It establishes the global configuration footprint:

- **Binary Cache Pre-Fetching**: Employs `https://niri.cachix.org` and its trusted public key to prevent local compilation of Niri packages during builds.
- **Default Display Manager Session**: Automatically sets `services.displayManager.defaultSession = "niri"`.
- **Portal Overrides**: Configures XDG Desktop Portals to route file-choosing, printing, and URI opening through `xdg-desktop-portal-gtk` while utilizing `xdg-desktop-portal-gnome` for other services.
- **Utilities**: Bundles auxiliary tools like `swappy` (screenshot annotation), `wtype` (Wayland input simulator), `waypaper` (for `awww` wallpaper daemon integration), `brightnessctl`, and more.

---

## Native Niri KDL Configuration Breakdown

Niri uses **KDL** for its native configuration. This config is defined inside the Home Manager block using the `programs.niri.config` parameter.

Below is a breakdown of the custom KDL configuration structure:

### 1. Global Parameters & Environment
- **`prefer-no-csd`**: Instructs client applications to prefer client-side window decoration suppression.
- **`hotkey-overlay`**: Suppresses the built-in keyboard overlay help panel at startup.
- **`environment`**: Injecting Wayland-native variables to bypass legacy X11 layers, specifically styling:
  - `NIXOS_OZONE_WL "1"`, `ELECTRON_OZONE_PLATFORM_HINT "wayland"`, `MOZ_ENABLE_WAYLAND "1"`
  - Disables Dank Material Shell's auto-generated Matugen wallpaper rules (`DMS_DISABLE_MATUGEN "0"`).

### 2. Autostart Daemons (`spawn-sh-at-startup`)
- Restarts and runs the `wlsunset` screen gamma daemon (running color temperature 3800K at night) on window manager boot.
- Initializes the `awww` background cycle daemon (`waypaper` wrapped via `wallpaper.nix`).
- Spawns Thunar in daemon mode for faster startups.

### 3. Hardware Inputs & Outputs
- **`input`**:
  - **`keyboard`**: Tracks the dynamic system layouts (`kbdLayout`, `kbdVariant`) with a quick repeat rate (35 repeats/sec) and a minimal repeat delay (275ms).
  - **`touchpad`**: Configures click method as `clickfinger`.
  - **`mouse`**: Implements flat mouse acceleration with `accel-speed 0.0`.
  - **`warp-mouse-to-focus`** & **`focus-follows-mouse`**: Focuses and warps the cursor context fluidly when switching tiled windows.
- **`output "desc:BOE 0x0690"`**: Locks down the integrated screen configuration with resolution `1920x1080@60.014Hz` and scaling `1.0`.
- **`workspace`**: Statically defines workspaces `"1"` and `"2"` to prevent dynamic cleanup.

### 4. Layout Style & Aesthetics
- **`layout`**:
  - **Gaps**: Standard padding is set to `8px`.
  - **Focus Behavior**: `center-focused-column "never"` ensures the current column does not snap to the center of the viewport.
  - **Borders**: Active windows get a border width of `1px` painted with the Stylix dynamic active accent color (`base0E`). Inactive borders are transparent.
  - **Preset Widths**: Configures column sizing ratios of `1/3`, `1/2`, and `2/3` of screen real estate.
- **`blur`**: Applies compositor-level glass blur with `3` passes, an offset of `3.0`, subtle `0.02` noise, and a `1.1` color saturation.
- **`overview`**: Disables drop shadows inside the workspace overview window switcher (`workspace-shadow off`).

### 5. Specialized Layer & Window Rules

#### Layer Rules (`layer-rule`)
- **Awww Wallpaper Daemon**: Matches `^awww-daemon$` and is explicitly placed within the backdrop.
- **Rofi Menu**: Rofi menus match `^rofi$` and are forced to display with rounded corners (`geometry-corner-radius 12`), noise, high saturation, and backdrop blur.
- **Dank Material Shell**: Forces realistic blur for `^dms:.*` popups without X-ray effects.

#### Window Rules (`window-rule`)
- **Corner Radii**: Applies a global 12px geometry corner radius and enables `clip-to-geometry` to ensure window contents stay within borders.
- **Full Opacity (1.0)**: Matches core browsers and multimedia software (`firefox`, `zen-beta`, `floorp`, `brave-`, `vlc`, `easyeffects`). Maximized to edges and borders are disabled.
- **Translucency (0.70 - 0.85)**: Terminals, system tools, code editors, and file managers apply varying degrees of backdrop blur and translucency.
- **Floating Apps**: Forces popups and overlay control panels (like `pavucontrol`, `blueman-manager`, `nm-applet`, `Picture-in-Picture`) to load as floating windows.

### 6. Interactive Keybindings (`binds`)

Hotkeys are structured around `Mod` (the Super/Windows key) for effortless navigation. Examples include:

- **Launchers**: `Mod + T` (Terminal), `Mod + F` (Firefox), `Mod + Space` (Rofi Drun), `Mod + Z` (Zen Browser), `Mod + C` (Editor).
- **Window Management**: 
  - `Mod + Left/Right` or `Mod + H/L`: Focus adjacent columns.
  - `Mod + K/J`: Focus stack windows vertically.
  - `Mod + M`: Maximize column.
  - `Mod + Shift + V`: Toggle window floating.
  - `Mod + W`: Switch focus between floating and tiling.
- **System**:
  - `Mod + Alt + L`: Lock screen (`swaylock`).
  - `Mod + P`: Interactive region screenshot (`grim` + `slurp` + `swappy`).
  - `Mod + F9/F10`: Toggle Night Light (`wlsunset`).
  - Audio and Brightness controls using `XF86` media keys.

---

## Declarative Theming (Stylix)

The entire Niri ecosystem, including backgrounds, GTK borders, Thunar accents, and Rofi themes, are unified by **Stylix** via the `modules/desktop/niri/stylix/default.nix` integration. It globally enforces Base16 colorschemes, dark modes, cursor properties, and font pairings without requiring manual hardcoded CSS scattered across different configurations.
