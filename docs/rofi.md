# Rofi Configuration & Theming

This document explains how Rofi is configured in the nixri setup, how it automatically synchronizes its theme with your global system aesthetics, and details the custom powermenu script.

## Overview

Rofi's entire configuration has been completely overhauled from legacy static `.rasi` files to a fully declarative Nix implementation via Home Manager. The main files are located at `modules/desktop/niri/rofi`:

- **`default.nix`**: The entry point that enables Rofi and declares the complete theme. It dynamically imports variables from the global `stylix` palette and constructs the CSS-like Rasi structures natively in Nix using `mkLiteral`.
- **`config.nix`**: Contains all the general Rofi settings, such as fuzzy matching, history tracking, sorting behavior, and generic keybindings for navigating lists.
- **`rofi-powermenu.nix`**: A standalone custom Rofi launcher specifically built to act as an elegant, icon-driven system exit menu.

---

## Declarative Theming (Stylix Integration)

Unlike traditional setups that require you to maintain dozens of external `colors.rasi` files or download pre-made themes from external repositories, nixri uses **Stylix** to colorize Rofi on the fly. 

Inside `default.nix` and `rofi-powermenu.nix`, the configuration explicitly pulls from `config.lib.stylix.colors` to dynamically build the exact highlight patterns for your system:

- `base00`: Background (`bgColor`)
- `base01`: Secondary Background (`bgAltColor`)
- `base05`: Text (`fgColor`)
- `base0E`: Selected Focus (`accentColor`)
- `base0B`: Active States (`activeColor`)
- `base08`: Urgent / Alert States (`urgentColor`)

Because the entire theme tree is generated at build time using `mkLiteral` structures, Rofi will perfectly match your system's global aesthetics whenever you change your base16 palette in `stylix/default.nix`. 

### Background Images
Rofi uses a fixed background image mapped directly from your Nix repository:
```nix
currentWallpaper = "${self}/modules/wallpapers/tree-rofi.jpg";
```
This image is embedded directly into the `inputbar` (and `imagebox` for the powermenu) natively. By keeping a smaller, optimized image (`tree-rofi.jpg`) rather than loading a massive 4K wallpaper, Rofi opens completely instantly without the micro-stutter typical of image-heavy launchers.

---

## Custom Powermenu (`rofi-powermenu`)

To provide a sleek and safe exit workflow, nixri implements a heavily stylized shutdown menu in `rofi-powermenu.nix`.

### Features
1. **System Controls**: Displays large, beautiful icons for Lock, Suspend, Logout, Hibernate, Reboot, and Shutdown.
2. **System Information**: Automatically pulls your `$USER`, `hostname`, and exact system `uptime` to display in the menu header.
3. **Safety Confirmation**: To prevent accidental shutdowns, clicking any destructive option triggers a secondary, centered Rofi confirmation window asking "Are you Sure?" with `Yes/No` checkmarks.
4. **Wayland Integration**: Safely interfaces with `systemctl` for hardware states and talks directly to the `niri` IPC to cleanly close the session on logout.

### Customizing the Powermenu

If you want to adjust the icon fonts or tweak the interactive prompts, you can edit the script portion located at the bottom of `rofi-powermenu.nix`:
```bash
lock='󰌾'
suspend='󰤄'
logout='󰍃'
# ...
```
To change its structural design, modify the `powermenuTheme` block at the top of the file, which dictates the spacing, border radii, and dimensions using the same Stylix colors as the main application launcher.
