# Core Modules Structure Overview

The `modules/core` directory contains the foundational building blocks of this NixOS configuration. Unlike the desktop or program-specific configurations, these modules represent the essential, universally applied settings required to get a functional, secure, and modern NixOS system up and running.

## Directory Context

- **Location:** `modules/core/`
- **Entry Point:** These modules are imported via the main `modules/default.nix` file. 

Each component is isolated into its own subdirectory (e.g., `modules/core/boot/default.nix`), keeping the configuration clean and strictly separated by concern.

---

## Key Core Components

The core modules are responsible for establishing the base layer of the operating system. They can be conceptually grouped as follows:

### System Initialization & Hardware

- **`boot`:** Configures the bootloader (typically `systemd-boot` or `grub`), kernel parameters, and early boot settings.
- **`hardware`:** Sets up core hardware enablement, including Bluetooth, OpenGL, and audio (Pipewire) configurations.
- **`network`:** Configures networking infrastructure, typically enabling NetworkManager, firewalls, and discovery services like Avahi.
- **`system`:** Manages universal system states like locale, timezone, Nix daemon settings (experimental features like flakes), and automatic garbage collection.

### User Environment & Shell

- **`users`:** Defines the primary user account, default shell, and necessary group memberships (e.g., `wheel`, `networkmanager`, `video`).
- **`bash` / `fish`:** System-wide shell configurations and aliases.
- **`starship`:** Cross-shell prompt configuration for a unified terminal experience.
- **`fonts`:** Installs and configures essential system fonts, including Nerd Fonts required for icons in Waybar and the terminal.
- **`xdg`:** Sets up XDG user directories (Documents, Downloads, etc.) and XDG Desktop Portals (crucial for Wayland screen sharing and flatpaks).

### Display & Security

- **`sddm`:** Configures the Simple Desktop Display Manager (SDDM) as the login screen, often including custom themes and avatars.
- **`security`:** Implements necessary security policies like Polkit (for GUI privilege escalation) and PAM configurations (e.g., for `swaylock`).

### Utilities & Services

- **`packages`:** A curated list of strictly essential, system-wide packages (like `git`, `wget`, `curl`) that should be available regardless of the desktop environment.
- **`services`:** Enables foundational daemons like `udisks2` (for mounting drives), `upower` (for battery management), `dbus`, and `gvfs`.
- **`nh`:** Configures `nh` (Nix Helper), providing a cleaner, faster alternative to standard `nixos-rebuild` commands.
- **`printing`:** Enables CUPS for local and network printing support.
- **`syncthing`:** Configures the Syncthing daemon for continuous file synchronization across devices.

## Philosophy

The `core` directory enforces a modular philosophy:

1. **Separation of Concerns:** If you want to change how networking is handled, you only need to look in `core/network`.
2. **Reusability:** By decoupling these from the desktop environment (niri), you could theoretically swap out niri for GNOME or KDE while retaining the exact same base system configuration.
