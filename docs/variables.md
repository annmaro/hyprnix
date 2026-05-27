# System Variables Configuration (`variables.nix`)

The `variables.nix` file located at `hosts/default/variables.nix` serves as the central configuration hub for your nixri system. This file allows you to quickly adjust the core aspects of your OS, user environment, and hardware setup without diving deep into the individual Nix modules.

## Structure

The file exports a set of variables grouped into three primary categories:

### 1. User Configuration

This section defines your preferred applications and user-specific settings.

- **`username`**: The primary user for the system (e.g., `"annmaro"`). This is typically set automatically during the installation process (`install.sh`, `live-install.sh`).
- **`desktop`**: Your chosen desktop environment or window manager.
  - *Options*: `hyprland`, `i3-gaps`, `gnome`, `plasma6`
- **`terminal`**: Your default terminal emulator.
  - *Options*: `kitty`, `alacritty`
- **`editor`**: Your preferred text editor, which dictates the system-wide editor and coding environment.
  - *Options*: `nixvim`, `vscode`, `antigravity`, `helix`, `nvchad`, `neovim`
- **`browser`**: Your default web browser.
  - *Options*: `firefox`, `floorp`, `zen`
- **`tuiFileManager`**: Your preferred terminal-based file manager.
  - *Options*: `yazi`, `lf`
- **`shell`**: Your default login shell.
  - *Options*: `zsh`, `bash`
- **`games`**: A boolean (`true` or `false`) that toggles the inclusion of the gaming module (installs Steam, Lutris, MangoHud, etc.).

### 2. Hardware Configuration

This section configures hardware-specific details crucial for a functional display and network presence.

- **`videoDriver`**: Defines the graphics driver for your system. **CRITICAL:** Ensure this matches your hardware to avoid display issues or lack of hardware acceleration.
  - *Options*: `nvidia`, `amdgpu`, `intel`
- **`hostname`**: The network identifier for your machine (e.g., `"nixri"`).

### 3. Localization

This section defines regional and input settings.

- **`clock24h`**: A boolean (`true` or `false`) that configures the clock format (e.g., in Waybar) to either 24-hour (`true`) or 12-hour (`false`).
- **`kbdLayout`**: Your keyboard layout (e.g., `"us"`).
- **`kbdVariant`**: The specific variant of your keyboard layout (often left as an empty string `" "` if standard).
- **`consoleKeymap`**: The keymap used in the TTY (e.g., `"us"`).

## How to Apply Changes

Whenever you modify a value in `variables.nix`, you must rebuild your NixOS system for the changes to take effect. You can typically do this by running your system rebuild script or standard `nixos-rebuild` command from the root of your `nixri` repository.
