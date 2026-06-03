# Services Configuration (`modules/core/services/default.nix`)

The `default.nix` file located at `modules/core/services/default.nix` manages the background services (daemons) necessary for a functional and responsive desktop experience on nixri.

## Structure

The file defines various configurations under the `services` attribute.

### 1. Essential System Services

This section enables core daemons required for hardware interaction and system optimization.

- **`libinput`**: Enables input handling for touchpads and mice.
- **`fstrim`**: Enables periodic SSD trimming to maintain disk performance and longevity.
- **`devmon`, `gvfs`, `udisks2`**: A combination of services required for automounting and interacting with removable media (like USB drives).
- **`dbus`**: Enables the D-Bus message bus system, which is crucial for inter-process communication in modern Linux desktops.

### 2. Secure Shell (OpenSSH)

Configures the SSH daemon for remote access.

- **`openssh.enable`**: Set to `true`.
- **`ports`**: Listens on standard port `22`.
- **`settings`**:
  - `PasswordAuthentication` & `KbdInteractiveAuthentication`: Enabled for standard login.
  - `AllowUsers`: Currently set to `null` (allows all users).
  - `PermitRootLogin`: Restricted to `"prohibit-password"` for security.

### 3. Desktop Integration Services

These services provide essential quality-of-life features for the desktop environment.

- **`blueman`**: Enables the Blueman Bluetooth manager.
- **`tumbler`**: Enables the D-Bus thumbnailing service, required for image and video previews in file managers.
- **`gnome.gnome-keyring`**: Enables the GNOME Keyring daemon for securely storing secrets, passwords, and keys.

### 4. Audio (PipeWire)

nixri uses PipeWire as its modern audio server, explicitly disabling the legacy PulseAudio daemon.

- **`pulseaudio.enable = false`**: Disables the old PulseAudio server.
- **`pipewire`**:
  - `enable`: Activates PipeWire.
  - `alsa`, `pulse`, `jack`: Enables emulation/support for all three major audio APIs, ensuring broad compatibility with applications.
  - **Low-Latency Configuration**:
    - The configuration includes custom JSON-like attribute sets (`extraConfig.pipewire."92-low-latency"` and `extraConfig.pipewire-pulse."92-low-latency"`) that force PipeWire to operate at a consistent base sample rate (`48000` Hz) and a fixed, low quantum (buffer size of `256`).
    - **Dynamic High-Res Switching**: PipeWire is configured with `default.clock.allowed-rates` (`[ 44100 48000 88200 96000 192000 ]`) to automatically switch to high-resolution sample rates when playing high-fidelity audio files.
    - This tuning significantly reduces audio latency, which is particularly beneficial for gaming and real-time audio processing.

## How to Apply Changes

Changes made to this file require a system rebuild. Run your system rebuild script or `nixos-rebuild` command to apply any modifications to your background services.
