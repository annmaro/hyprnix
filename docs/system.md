# System Configuration (`modules/core/system/default.nix`)

The system config file located at `modules/core/system/default.nix` serves as the core system configuration for your nixri setup. It manages Nix settings, localization, package manager defaults, and essential environment variables.

## Structure

The file is structured to define global settings and services. It inherits variables from your host-specific `variables.nix` (such as keyboard layout and console keymap) to apply them system-wide.

### 1. Programs and Services

This section enables essential programs and background services.

- **`nix-index-database.comma`**: Enabled to allow running programs without installing them using the `,` (comma) command.
- **`gnupg.agent`**: Enables the GnuPG agent, including SSH support, for managing keys securely.
- **`services.xserver`**: While nixri is Wayland-based (Hyprland), basic xserver configuration is provided to ensure tools like `localectl` work correctly by exporting the XKB configuration (keyboard layout and variant).

### 2. Nix Package Manager Settings

This section heavily configures how Nix operates on your system.

- **`settings`**:
  - `download-buffer-size`: Increased to `200000000` to prevent issues when downloading large files.
  - `auto-optimise-store`: Enabled to automatically hardlink identical files in the Nix store, saving disk space at the cost of slightly longer rebuild times.
  - `substituters` & `trusted-public-keys`: Defines external binary caches (like NixOS, nix-community, chaotic-nyx, nix-gaming, and hyprland) to speed up package installations by downloading pre-built binaries instead of compiling from source.
  - `experimental-features`: Enables modern Nix features, specifically `nix-command` and `flakes`.
- **`optimise.automatic`**: Schedules automatic Nix store optimization.
- **`package`**: Uses the latest version of Nix (`pkgs.nixVersions.latest`).

### 3. Time and Localization

This section defines your regional settings.

- **`time.timeZone`**: Sets the system timezone (e.g., `"Asia/Kolkata"`).
- **`i18n`**: Configures the default locale (`en_US.UTF-8`) and extra locale settings (like formatting for address, time, monetary values) to a specific region (e.g., `"en_IN"`).

### 4. Environment Variables

Defines critical environment variables that are loaded early during the boot/login process.

- **`NIXOS_OZONE_WL`**: Set to `"1"` to force Electron apps to use Wayland natively.
- **XDG Base Directories**: Explicitly defines standard directories (`XDG_CACHE_HOME`, `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_BIN_HOME`, `XDG_RUNTIME_DIR`) to prevent race conditions during load order, ensuring user configurations and data are placed correctly.

### 5. Nixpkgs and State Version

- **`console.keyMap`**: Sets the TTY keymap based on `variables.nix`.
- **`nixpkgs.overlays`**: Applies all defined overlays to modify or extend packages.
- **`nixpkgs.config.allowUnfree`**: Enabled (`true`) to allow the installation of proprietary software (like NVIDIA drivers, Discord, Steam).
- **`system.stateVersion`**: Indicates the NixOS release version the system was initially installed with. **CRITICAL: Do not change this value**, as it manages stateful data compatibility.

## How to Apply Changes

Changes made to this file require a system rebuild to take effect. Run your system rebuild script or `nixos-rebuild` command to apply the new system-wide configurations.
