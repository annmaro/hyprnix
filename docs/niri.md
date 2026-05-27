# Niri Configuration Structure Overview

Niri is a highly customisable, scrollable-tiling window manager/compositor for Wayland. In this NixOS configuration, the entire desktop setup is consolidated within the modular directory at `modules/desktop/niri`. 

This documentation explains how the Niri ecosystem is organized, how its components interact, and details the specific native KDL configuration structure that orchestrates the desktop environment.

---

## Modular Directory Structure

The `modules/desktop/niri` configuration is divided into highly-specialized components to ensure clean modularity and easy styling overrides:

- **[default.nix](file:///home/annmaro/hyprnix/modules/desktop/niri/default.nix)**: The main entry point. It sets system-wide variables, enables binary caches, sets the default session, installs system-wide packages, defines GNOME/GTK portal overrides, and hosts the native KDL configurations via Home Manager.
- **[dms/](file:///home/annmaro/hyprnix/modules/desktop/niri/dms/default.nix)**: Orchestrates the **Dank Material Shell (DMS)** framework. See the dedicated [dms.md](file:///home/annmaro/hyprnix/docs/dms.md) documentation for full details on enabled features, integration settings, and styling patches.
- **[rofi/](file:///home/annmaro/hyprnix/modules/desktop/niri/rofi/default.nix)**: Installs and customizes **Rofi** to serve as the application launcher, clipboard history UI, and emoji menu. It features a custom Catppuccin Macchiato design.
- **[themes/](file:///home/annmaro/hyprnix/modules/desktop/niri/themes/default.nix)**: Manages look-and-feel across all toolkit contexts.
  - **[gtk.nix](file:///home/annmaro/hyprnix/modules/desktop/niri/themes/gtk.nix)**: Enforces GTK2/3/4 themes (Catppuccin Mocha-Mauve compact), cursor styling (Bibata Modern Classic size 24), dark mode databases, and Libadwaita overrides.
  - **[qt.nix](file:///home/annmaro/hyprnix/modules/desktop/niri/themes/qt.nix)**: Configures Qt integration using **Kvantum** with a Catppuccin theme and the `qt5ct`/`qt6ct` tools.

---

## Core Configuration: `default.nix`

`default.nix` is the heart of the Niri setup. It establishes the global configuration footprint:

- **Binary Cache Pre-Fetching**: Employs `https://niri.cachix.org` and its trusted public key to prevent local compilation of Niri packages during builds.
- **Default Display Manager Session**: Automatically sets `services.displayManager.defaultSession = "niri"`.
- **Portal Overrides**: Configures XDG Desktop Portals to route file-choosing, printing, and URI opening through `xdg-desktop-portal-gtk` while utilizing `xdg-desktop-portal-gnome` for other services.
- **Utilities**: Bundles auxiliary screenshot tools (`grim`, `slurp`, `swappy`), volume mixers (`pamixer`, `pavucontrol`), clipboard history engines (`cliphist`), backlight hooks (`brightnessctl`), and temperature adjustments (`wlsunset`).

---

## Native Niri KDL Configuration Breakdown

Niri uses **KDL** (a modern, structured document language) for its native configuration. This config is defined inside the Home Manager block using the `programs.niri.config` parameter.

Below is a breakdown of the custom KDL configuration structure:

### 1. Global Parameters & Environment
- **`prefer-no-csd`**: Instructs client applications to prefer client-side window decoration suppression.
- **`hotkey-overlay`**: Suppresses the built-in keyboard overlay help panel at startup (`skip-at-startup`).
- **`environment`**: Injecting Wayland-native variables to bypass legacy X11 layers, specifically styling:
  - `NIXOS_OZONE_WL "1"`, `ELECTRON_OZONE_PLATFORM_HINT "wayland"` (Wayland support in Chromium/Electron)
  - `GDK_BACKEND "wayland,x11,*"` (GTK apps)
  - `MOZ_ENABLE_WAYLAND "1"` (Firefox support)
  - Disables Dank Material Shell's auto-generated Matugen wallpaper rules (`DMS_DISABLE_MATUGEN "1"`).

### 2. Autostart Daemons (`spawn-sh-at-startup`)
- Restarts and runs the `wlsunset` screen gamma daemon (running color temperature 3800K at night) on window manager boot.

### 3. Hardware Inputs & Outputs
- **`input`**:
  - **`keyboard`**: Tracks the dual layouts `"us,in"` (US and India) with a quick repeat rate (35 repeats/sec) and a minimal repeat delay (275ms).
  - **`touchpad`**: Configures click method as `clickfinger`.
  - **`mouse`**: Implements flat mouse acceleration with `accel-speed 0.0`.
  - **`warp-mouse-to-focus`** & **`focus-follows-mouse`**: Focuses and warps the cursor context fluidly when switching tiled windows.
- **`output "desc:BOE 0x0690"`**: Locks down the integrated screen configuration with resolution `1920x1080@60.014Hz`, scaling `1.0`, and position coordinate `x=0 y=0`.
- **`workspace`**: Statically defines workspaces `"1"` and `"2"` to prevent dynamic cleanup.

### 4. Layout Style & Aesthetics
- **`layout`**:
  - **Gaps**: Standard padding is set to `9px`.
  - **Focus Behavior**: `center-focused-column "never"` ensures the current column does not snap to the center of the viewport.
  - **Borders**: Active windows get a border width of `1px` painted in active mauve (`#ca9ee6`), while inactive ones feature a light blue-lavender border (`#b4befe`).
  - **Preset Widths**: Configures column sizing ratios of `1/3`, `1/2`, and `2/3` of screen real estate.
- **`blur`**: Applies compositor-level glass blur with `3` passes, an offset of `3.0`, subtle `0.02` noise, and a `1.1` color saturation.
- **`overview`**: Disables drop shadows inside the workspace overview window switcher (`workspace-shadow off`).

### 5. Specialized Layer & Window Rules
Window states and styles are applied dynamically using match patterns on application `app-id` or window class/title:

#### Layer Rules (`layer-rule`)
- **Quickshell & Backgrounds**: Layer rules applied to the namespace matching `^quickshell$|^dms:blurwallpaper$` enforce a background-effect with high blur, `0.03` noise, and a `1.25` color saturation factor.
- **Rofi Menu**: Rofi menus match `^rofi$` and are forced to display with rounded corners (`geometry-corner-radius 12`) and high-density backdrop blur.

#### Window Rules (`window-rule`)
- **Full Opacity (1.0)**: Matches core browsers and multimedia software (`firefox`, `zen-beta`, `floorp`, `brave-`, `vlc`, `easyeffects`, `gapless`).
- **Terminal Translucency (0.80)**: Matches terminal systems (`kitty`, `neovim`, `com.mitchellh.ghostty`, `Alacritty`, `org.wezfurlong.wezterm`) to apply backdrop blur and minor transparency.
- **Utility & System Translucency (0.80)**: Matches file managers and settings panels (`org.gnome.Nautilus`, `thunar`, `pcmanfm`, `spotify`, etc.).
- **Code Editor & Chat Translucency (0.85)**: Matches editors and chat suites (`Emacs`, `obsidian`, `discord`, `vesktop`, `VSCodium`, `code`, `antigravity`).
- **Floating Apps**: Forces popups and overlay control panels (like `pavucontrol`, `blueman-manager`, `nm-connection-editor`, `Signal`, and standard browser `Picture-in-Picture`) to load as floating windows.

### 6. Interactive Keybindings (`binds`)
Hotkeys are structured around `Mod` (the Super/Windows key) for effortless navigation:

| Key Binding | Action / Spawned Tool | Description |
| ----------- | --------------------- | ----------- ||
| `Mod + T`                     | Kitty Terminal                       | Spawn the default fast terminal                            |
| `Mod + F`                     | Firefox Browser                      | Opens the web browser                                      |
| `Mod + Space`                 | `rofi -show drun`                    | Activates application launcher                             |
| `Mod + V`                     | `rofi -show clipboard`               | Launches clipboard manager history selection               |
| `Mod + Z`                     | `rofi -show emoji`                   | Launches character / emoji picker                          |
| `Mod + Q`                     | `close-window`                       | Closes active focused window                               |
| `Mod + W`                     | `toggle-window-floating`             | Toggles floating state of current window                   |
| `Mod + Alt + L`               | `dms session lock`                   | Triggers lock screen                                       |
| `Mod + Backspace`             | `wlogout`                            | Launches desktop exit session menu                         |
| `Mod + Left` / `H`            | `focus-column-left`                  | Focuses the tile on the left                               |
| `Mod + Right` / `L`           | `focus-column-right`                 | Focuses the tile on the right                              |
| `Mod + K` / `J`               | `focus-window-up / down`             | Focuses stack windows vertically                           |
| `Mod + Ctrl + Left` / `Right` | `move-column-left / right`           | Slides the active column horizontally                      |
| `Mod + Ctrl + K` / `J`        | `move-column-to-workspace-up / down` | Shifts columns between workspace floors                    |
| `Mod + S`                     | `overview toggle`                    | Toggles the Niri visual workspace grid overview            |
| `Mod + R`                     | `switch-preset-column-width`         | Cycles through preset column sizing proportions            |
| `Mod + M`                     | `maximize-column`                    | Expands column size to maximum width                       |
| `Alt + Return`                | `fullscreen-window`                  | Fullscreens active focused window                          |
| `Mod + 1 / 2 / 3`             | `focus-workspace 1 / 2 / 3`          | Switches active workspace                                  |
| `Mod + Shift + 1..5`          | `move-column-to-workspace 1..5`      | Sends active column to a specific workspace                |
| `Mod + P` / `Mod+Ctrl+P`      | Grim + Slurp + Swappy                | Take interactive screenshots and open annotator            |
| `XF86Audio*`                  | volume controls                      | Adjusts or mutes audio outputs/inputs via `pamixer`        |
| `XF86MonBrightness*`          | brightness adjustments               | Changes panel backlight intensity via `brightnessctl`      |
| `XF86AudioPlay/Next*`         | media controller                     | Media control routing (play, pause, track) via `playerctl` |
---

## Launcher Configurations (Rofi)

Rofi provides the search and input interfaces under `rofi/default.nix`:
- Integrates with clipboard daemons (`cliphist`) and emoji charts.
- Custom styled using Home Manager overlays, forcing a gorgeous, custom dark theme with high-visibility accents (JetBrains Mono Nerd Font, lavender/macchiato styling) that matches the global workspace aesthetics.

---

## Declarative GTK & QT Theming

The style engine settings in `themes/` declare uniform appearance variables for both legacy and Libadwaita environments:
- **Bibata Cursors**: Biblical/bibata Modern Classic cursors are pinned to size 24.
- **Libadwaita Color Schemes**: Pinned to `prefer-dark` globally inside the user `dconf` database, forcing GTK4 apps to follow dark styling parameters.
- **GTK Compaction**: Injecting custom compact `catppuccin-mocha-mauve` style assets directly into user `gtk-4.0` config directories.
- **Qt Styling**: Hooks up the **Kvantum** theme controller alongside `qt5ct`/`qt6ct` to align Qt-based programs with the overall dark color theme.
