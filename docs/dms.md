# Dank Material Shell (DMS) Details

**Dank Material Shell (DMS)** is a modern, premium, and Material 3-inspired desktop shell built specifically for Wayland compositors using **Quickshell** and **Go**. 

In this system configuration, DMS is declared as a flake input from:
> **Source Repository**: `github:AvengeMedia/DankMaterialShell/stable` (see [flake.nix](file:///home/annmaro/hyprnix/flake.nix#L20-L23))

Rather than serving as a basic bar, DMS functions as an all-in-one system dashboard, notification hub, lock screen, and session management suite.

---

## Enabled Features & Configuration

All active features of the Dank Material Shell are configured within the modular Nix block under [modules/desktop/niri/dms/default.nix](file:///home/annmaro/hyprnix/modules/desktop/niri/dms/default.nix). By declaring `programs.dank-material-shell.enable = true`, the following selected features have been customized and enabled in this profile:

### 1. Unified Status Bar (`modules.bar = true`)
The shell renders a premium top bar, custom-tailored with the following layout and design variables:
- **Floating Pill Architecture**: Configured as `floating = true` with a `margin = 8`, `height = 48`, and `borderRadius = 12`.
- **Capsule-only Aesthetic**: The background transparency is set to `0.01` while widget opacity is `0.90`. This hides the horizontal bar track completely, displaying individual widgets as clean, floating capsule pills hovering over the desktop.
- **Minimalist Workspaces**: The workspace switcher (`workspaceSwitcher`) uses a pill-indicator layout with text labels hidden (`show_labels = false`) for a cleaner visual profile.
- **Custom Widget Layout**:
  - **Left Area**: `workspaceSwitcher`, `focusedWindow`
  - **Center Area**: `clock` (for elegant central timekeeping)
  - **Right Area**: `weather` widget, `systemTray`, resource monitors (`cpuUsage` and `memUsage`), and the `controlCenterButton`.
- **Interactive Control Center Applets**: Clicking the status bar network and audio icons automatically triggers their respective system applets (`network_click_action = "applet"`, `audio_click_action = "applet"`).

### 2. Notification Daemon (`modules.notifications = true`)
- Replaces standard standalone notification daemons (like Mako or Dunst) by acting as the system-wide desktop notification server, processing toasts, sound hooks, and managing notifications in a slide-out drawer dashboard.

### 3. Session & Lock Screen Control (`modules.lockscreen = true` / `modules.idle = true`)
- Enables built-in desktop idle timers and lock screen engines.
- Integrated natively with the compositor. Pressing `Mod + Alt + L` executes `dms session lock` to immediately trigger the premium lock screen interface.

### 4. Background & Wallpaper Management (`modules.wallpaper = true`)
- Drives system wallpaper presentation. 
- To keep the system visual flow stable, auto-generated theme-changing rules are bypassed (`DMS_DISABLE_MATUGEN = "1"`). 
- Compositor layer rules (matching the namespaces `^quickshell$` and `^dms:blurwallpaper$`) are applied directly in Niri to inject active backdrop glass blur, minor noise (`0.03`), and elevated color saturation (`1.25`) behind wallpaper widgets.

### 5. Conflict Resolution & Seamless Niri Integration
- **Keybind & Autostart Decoupling**: Sets `niri.enableKeybinds = false` and `niri.enableSpawn = false`. This disables DMS's default internal hotkeys and launch daemons to prevent them from interfering with custom keybind layouts and autostarts defined in the primary KDL configurations.

### 6. Hi-DPI Scaling & Systemd Integration
- Leverages the systemd user service environment by exporting `QT_SCALE_FACTOR=1.3`. This forces all DMS Qt-based panel elements to scale to 130% size, keeping widgets readable and perfectly proportioned on Hi-DPI displays.

### 7. Custom Styling & Package Overlay
- **BasePill.qml Patch**: Configured via the Nixpkgs modification overlay in [overlays/default.nix](file:///home/annmaro/hyprnix/overlays/default.nix#L22-L27). During the compilation/patch phase of the package, the `BasePill.qml` layout file is modified to insert a gorgeous custom border design:
  ```qml
  Rectangle {
      anchors.fill: parent;
      color: dmsTheme.colors.surfaceContainer;
      radius: gothCornersEnabled ? gothCornerRadius : 12;
      border.width: 2;
      border.color: "#5895dc";
      z: -1
  }
  ```
  This creates a highly-stylized outline effect (colored in `#5895dc` with corner rounding that respects the global `gothCornersEnabled` system variables) around all bar widgets.

---

## Packages & Dependencies

To support the complete functionality of this shell, the module declaims and installs the following package hooks:
- **`dgop`**: Core system performance-tracking daemon required for real-time CPU/RAM status bar reporting.
- **`nerd-fonts.jetbrains-mono`**: Monospace font applied across text layouts and terminal integrations.
- **`material-symbols` & `material-design-icons`**: Complete modern icon packs utilized by DMS status bar capsules.
