# Waybar Configuration Structure Overview

The Waybar configuration for the Hyprland setup is located at `modules/desktop/hyprland/programs/waybar/default.nix`. It uses Home Manager to declaratively define both the functionality (settings/modules) and the aesthetics (CSS styling) of the status bar. 

## Directory Context

- **Config File:** `modules/desktop/hyprland/programs/waybar/default.nix`
- **Dependencies (Scripts):** Many custom modules rely on utility bash scripts located in `modules/desktop/hyprland/scripts/`.

---

## Configuration Details

The `default.nix` file is structured into two main sections: `settings` and `style`.

### 1. Settings (Layout and Modules)

The `settings` block defines the general behavior, position, and layout of Waybar.

- **Global Settings:** Positioned at the `top`, acting as a `dock`, exclusively occupying space, and utilizing `gtk-layer-shell` for proper Wayland compositing.
- **Layout Modules:** The bar is horizontally split into three sections:
  - **Left (`modules-left`):** Contains system monitors (CPU, Memory, GPU info, Temperature) grouped together (`group/gleft1`), followed by the active window's title.
  - **Center (`modules-center`):** Contains the Hyprland workspaces and the MPRIS media player controller.
  - **Right (`modules-right`):** Contains custom weather information, hardware status indicators grouped together (`group/gright1` for Battery, Backlight, Audio, Network), a clock/calendar, and a final group (`group/gright2`) for the system tray, notifications, and power menu.

#### Notable Custom Modules

Waybar is heavily customized using external scripts and advanced JSON returns:

- **`custom/notification`:** Integrates with `swaync-client` to display a dynamic notification bell, toggling the swaync control center on click.
- **`custom/weather`:** Uses a script (`weather.sh`) to fetch and display weather conditions.
- **`custom/gpuinfo`:** Uses a script (`gpuinfo.sh`) to fetch and display current GPU utilization and stats.
- **`cava` / `custom/cava_mviz`:** Audio visualizer integrated directly into the bar.
- **`hyprland/workspaces`:** Customized workspace icons that react to active/urgent states and allow clicking to switch workspaces.
- **`hyprland/window`:** Uses regex rewrite rules to beautifully format application names with icons (e.g., Firefox, VS Code, Spotify).

### 2. Styling (CSS)

The `style` block defines the visual appearance using CSS, directly embedded within the Nix file.

- **Color Palette:** The configuration defines and heavily utilizes a **Catppuccin** color palette (`base`, `mantle`, `blue`, `mauve`, `peach`, etc.) to ensure a consistent, beautiful theme.
- **Fonts:** Uses `JetBrainsMono Nerd Font` for clean typography and sharp icons.
- **Aesthetics:**
  - **Backgrounds:** The main bar background is transparent, relying on distinct pill-shaped backgrounds for individual module groups.
  - **Borders & Shadows:** Module groups (`#gleft1`, `#gright1`, etc.) use highly rounded borders (`border-radius: 30px`), semi-transparent borders, and drop shadows to create a floating, modern "pill" effect.
  - **Animations:** Includes smooth CSS keyframe animations (like `blink` for critical battery, or `blink-condition` for rain/snow weather) to organically draw the user's attention.
  - **Interactive Elements:** Workspaces and taskbar buttons have hover transitions and active states that smoothly change colors and dynamically adjust width.
