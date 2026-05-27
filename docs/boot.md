# Boot Configuration (`modules/core/boot/default.nix`)

The `default.nix` file located at `modules/core/boot/default.nix` manages the foundational boot settings for your nixri system. This file handles everything from kernel parameters and filesystems to the bootloader setup and AppImage support.

## Structure

The file defines several settings nested under the `boot` configuration attribute:

### 1. Filesystems and Basic Boot Settings

This section outlines support for different filesystems and temporary file handling.

- **`supportedFilesystems`**: Ensures the system can interact with multiple disk formats, including `ntfs`, `exfat`, `ext4`, `fat32`, and `btrfs`.
- **`tmp.cleanOnBoot`**: A boolean (`true`) indicating that the temporary directory (`/tmp`) will be cleaned every time the system boots.

### 2. Kernel Configuration

This section defines the core Linux kernel to be used along with specific parameters to tune system performance.

- **`kernelPackages`**: Specifies the Linux kernel to use. By default, this is set to the Zen kernel (`pkgs.linuxPackages_zen`) which is optimized for desktop usage and responsiveness. Other options include `_latest`, `_hardened`, `_rt`, etc.
- **`kernel.sysctl`**: Sets sysctl variables. Here, `vm.swappiness` is set to `100`, which is often tuned for setups using zRAM to maximize memory compression efficiency.
- **`kernelParams`**: Defines arguments passed to the kernel at boot. Currently, it uses `"preempt=full"` to prioritize lower latency at the expense of slight throughput reductions—ideal for desktop and gaming environments.

### 3. Bootloader (GRUB & EFI)

This configuration uses GRUB as the primary bootloader and explicitly disables systemd-boot.

- **`loader.systemd-boot.enable`**: Set to `false`.
- **`loader.efi`**:
  - `canTouchEfiVariables`: Set to `true`, allowing the installation process to modify EFI variables.
  - `efiSysMountPoint`: Mounts the EFI partition at `/boot`.
- **`loader.timeout`**: Sets the boot menu display duration to `10` seconds.
- **`loader.grub`**:
  - `enable`: Set to `true` to use GRUB.
  - `efiSupport`: Enabled to support UEFI systems.
  - `useOSProber`: Enabled (`true`) to detect and include other operating systems (like Windows or other Linux distros) in the GRUB menu.
  - **`theme`**: A custom GRUB theme is applied by downloading and installing the "distro-grub-themes" (NixOS variant) from GitHub.

### 4. AppImage Support

This section registers a binary format (binfmt) to allow AppImages to run seamlessly.

- **`binfmt.registrations.appimage`**: Configures the kernel to recognize the AppImage magic bytes (`\x7fELF....AI\x02`) and automatically execute them using the `${pkgs.appimage-run}/bin/appimage-run` interpreter. This means you can simply execute AppImages without needing to prefix them with a runner command.

## How to Apply Changes

Changes made to this file require a system rebuild. If you alter critical boot settings (like the bootloader or kernel), it is highly recommended to run the rebuild script and verify the output for any errors before rebooting your machine.
