# Analysis of the NixOS Flake Installer Script

This document breaks down the `installer` shell script into plain, easy-to-understand terms. The script is designed to automate either a fresh NixOS installation from a Live ISO or update an existing NixOS system using Nix Flakes.

---

## 1. Core Functions of the Script

The script performs three primary tasks:
1. **Detects the Environment:** It checks whether you are running it from a temporary Live ISO (to install NixOS) or from an already installed NixOS system (to update it).
2. **Collects User Preferences:** It prompts you for basic system settings (username, hostname, password, and graphics driver).
3. **Executes Setup/Updates:** 
   * **For New Installs:** It formats your storage, installs NixOS, sets up user profiles, and configures the hardware.
   * **For Existing Systems:** It safely cleans up old configurations, updates hardware detection files, and rebuilds the system.

---

## 2. Step-by-Step Code Execution Flow

The script runs in the following sequence:

### Step 1: Environment Check and Tool Loading
* The script checks if `/iso` exists or if the root system is loaded in temporary memory (`tmpfs`).
* **If on a Live ISO:** It automatically downloads and opens a temporary shell containing `git`, `pciutils` (for hardware checking), and `disko` (for partition management) so the installer has all required tools.
* **Privilege Check:** 
  * If on a Live ISO, the script insists on being run as root (`sudo`).
  * If on an already installed system, it insists on being run as a normal user to avoid configuration ownership issues.

### Step 2: System Configuration Prompts
The script asks you for:
* **Username:** The name of your user account (defaulting to your current user).
* **Hostname:** The network name for your computer (defaulting to `nixos`).
* **Password:** Securely prompts you to type and confirm a password.
* **GPU Driver:** Prompts you to select your graphics card manufacturer: Nvidia, AMD, or Intel.

---

### Step 3: Deployment Route Selection

The script splits into two different pathways depending on its environment check:

#### PATH A: Fresh Installation (Live ISO Mode)

**WARNING: Partitioning disks and formatting drives will permanently destroy existing data. Ensure you have backed up any crucial files before proceeding.**

You are given three disk options:

1. **Option 1 (Automated Wipe):** Uses the `disko` tool to completely wipe and format an entire selected drive (e.g., `sda` or `nvme0n1`).
2. **Option 2 (Custom Partitions):** Allows you to choose pre-existing system partitions manually. It formats the EFI partition to `vfat` and the root partition to `Btrfs`, creating the subvolumes `@`, `@home`, and `@nix`.
3. **Option 3 (Personal Quick-Default):** Automatically wipes and formats `/dev/sda1` and `/dev/sda2` using default `disko` templates.

Once partitioning is complete, the script:
* Copies your NixOS configuration files to `/mnt/etc/nixos`.
* Generates a clean hardware configuration file, deliberately ignoring sensitive mount paths like `secrets` or `rclone`.
* Swaps your chosen username and graphics driver into the variables configuration file.
* Runs `nixos-install` to build and install the operating system.
* Sets your user password on the newly installed system.
* Creates default directories (Downloads, Documents, etc.) in your home folder and copies your NixOS configuration files there for future edits.

#### PATH B: Existing System Upgrade Mode

If the script is run on an already functioning NixOS system, it:
* Updates your username and graphics driver choices in the local variables file.
* Deletes old, conflicting profile files for Firefox, Zen Browser, GTK configurations, and Cava to prevent configuration conflicts.
* Reads your current machine's physical hardware structure and writes a clean hardware file to `hosts/default/hardware-configuration.nix`.
* Stage-adds this hardware file to your local Git directory.
* Runs `sudo nixos-rebuild switch --flake .#default` to rebuild and apply your updated configuration.

---

## 3. Post-Installation Note

At the end of either pathway, a yellow warning banner appears reminding you that:
* Encrypted secrets config files (`sops, git config`) have been skipped.
* Git signing keys and cloud storage connections (`rclone`) were not configured automatically.
* You must set these up manually after logging in.