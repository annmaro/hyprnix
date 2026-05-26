#!/usr/bin/env bash
set -e

# Colors for clean terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "\n${GREEN}$1${NC}"; }
warn() { echo -e "${YELLOW}$1${NC}"; }
error() { echo -e "${RED}Error: $1${NC}" >&2; }

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE}    Welcome to the Unified NixOS Flake Installer     ${NC}"
echo -e "${BLUE}=====================================================${NC}"

# 1. Determine Environment
IS_LIVE_ISO=false
if [ -d "/iso" ] || [ "$(findmnt -o FSTYPE -n /)" = "tmpfs" ]; then
    IS_LIVE_ISO=true
    info "Environment Detected: NixOS Live ISO Installation"
else
    info "Environment Detected: Installed NixOS System Modification"
fi

# --- AUTO-WRAPPER ENVIRONMENT BOOTSTRAP ---
# If on Live ISO and flags aren't enforced yet, restart inside a nix shell with Git and Flakes enabled
if $IS_LIVE_ISO && [ -z "$NIX_FLAGS_ENFORCED" ]; then
    info "Enabling Flake features and preparing environment tools..."
    export NIX_FLAGS_ENFORCED=1
    # Exec into nix shell with necessary utilities, then relaunch script running as root via sudo
    exec nix shell nixpkgs#git nixpkgs#pciutils nixpkgs#parted nixpkgs#cryptsetup --extra-experimental-features "nix-command flakes" -c sudo -E "$0" "$@"
    exit $?
fi

# Privilege validations depending on execution context
if $IS_LIVE_ISO; then
    if [ "$(id -u)" != "0" ]; then
        error "When running on a Live ISO, this script must be run as root."
        exit 1
    fi
else
    if [[ $EUID -eq 0 ]]; then
        error "On an installed system, do not run this script directly as root/sudo! Run it as a normal user."
        exit 1
    fi
fi

if [[ ! "$(grep -i nixos </etc/os-release)" ]]; then
    error "This installation script only works on NixOS!"
    exit 1
fi

currentUser=$(logname 2>/dev/null || echo "$USER")

# 2. Universal Interactive Prompts
info "Configuration Setup:"

# Username prompt
while true; do
    read -rp "Enter desired username [default: $currentUser]: " username
    username=${username:-$currentUser}
    if [[ "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then break; fi
    error "Invalid username format. Use lowercase letters, numbers, underscores, or hyphens."
done

# Hostname prompt
read -rp "Enter desired system hostname [default: nixos]: " hostname
hostname=${hostname:-nixos}

# Password prompt
while true; do
    read -rsp "Enter password for $username: " password; echo ""
    read -rsp "Confirm password: " password_confirm; echo ""
    if [ "$password" = "$password_confirm" ]; then
        if [ -z "$password" ]; then error "Password cannot be empty."; else break; fi
    else
        error "Passwords do not match. Try again."
    fi
done

# GPU Driver selection
info "Select your system GPU Driver:"
echo "1) nvidia"
echo "2) amdgpu"
echo "3) intel"
while true; do
    read -rp "Enter choice (1, 2 or 3): " driver_choice
    case $driver_choice in
        1) driver="nvidia"; break ;;
        2) driver="amdgpu"; break ;;
        3) driver="intel"; break ;;
        *) error "Invalid choice. Choose 1, 2, or 3." ;;
    esac
done

# 4. Environment Branch Execution
if $IS_LIVE_ISO; then
    # --- LIVE ISO ROUTINE ---
    info "Beginning Drive Partitioning Configuration..."
    
    # Prompt for Target disk
    echo "Available disks:"
    lsblk -d -o NAME,SIZE,MODEL | grep -v loop
    while true; do
        read -rp "Enter disk name to completely wipe & format (e.g., sda, nvme0n1): " disk
        if [ -b "/dev/$disk" ]; then break; fi
        error "Invalid disk target chosen."
    done

    # Interactive Encryption Choice
    info "Encryption Options:"
    echo "1) Yes, encrypt the root partition using LUKS"
    echo "2) No, leave the system unencrypted"
    while true; do
        read -rp "Enable full disk encryption? (1 or 2): " luks_choice
        case $luks_choice in
            1) encrypt_system=true; break ;;
            2) encrypt_system=false; break ;;
            *) error "Invalid choice. Enter 1 or 2." ;;
        esac
    done

    # Handle separate LUKS password prompt if encryption is requested
    if $encrypt_system; then
        info "Set LUKS encryption password for your storage root:"
        while true; do
            read -rsp "Enter LUKS password: " luks_password; echo ""
            read -rsp "Confirm LUKS password: " luks_password_confirm; echo ""
            if [ "$luks_password" = "$luks_password_confirm" ]; then
                if [ -z "$luks_password" ]; then error "LUKS password cannot be empty."; else break; fi
            else
                error "Passwords do not match. Try again."
            fi
        done
    fi

    warn "WARNING: This will destroy all data on /dev/$disk."
    read -rp "Proceed with formatting and full install? (Y/n): " confirm
    if [[ "$confirm" =~ ^[nN]$ ]]; then error "Aborted."; exit 1; fi

    # Partition targets assignment
    if [[ "/dev/$disk" =~ nvme ]]; then
        part_boot="${disk}p1"; part_root="${disk}p2"
    else
        part_boot="${disk}1"; part_root="${disk}2"
    fi

    # Wipe & Layout Setup (1GB EFI storage, NO Swap, Remaining space for Root)
    wipefs -af "/dev/$disk"
    parted -s "/dev/$disk" \
        mklabel gpt \
        mkpart primary fat32 1MiB 1025MiB \
        set 1 esp on \
        mkpart primary 1025MiB 100%

    # Format EFI Partition
    mkfs.fat -F32 "/dev/$part_boot"

    # Conditional Encryption Setup
    if $encrypt_system; then
        info "Setting up Root LUKS Encryption Wrapper Container..."
        echo -n "$luks_password" | cryptsetup luksFormat "/dev/$part_root" -
        echo -n "$luks_password" | cryptsetup luksOpen "/dev/$part_root" luks-root -
        root_device="/dev/mapper/luks-root"
    else
        info "Proceeding with standard unencrypted partition arrangement..."
        root_device="/dev/$part_root"
    fi

    # --- BTRFS SUBVOLUME LAYOUT INJECTION ---
    info "Formatting and creating Btrfs subvolumes..."
    mkfs.btrfs -f "$root_device"
    
    # Temporary mount to create subvolumes
    mkdir -p /mnt
    mount "$root_device" /mnt
    btrfs subvolume create /mnt/root
    btrfs subvolume create /mnt/home
    btrfs subvolume create /mnt/nix
    umount /mnt

    # Remount subvolumes with the correct flags
    info "Mounting subvolumes with zstd compression..."
    mount -o compress=zstd,subvol=root "$root_device" /mnt
    mkdir -p /mnt/{home,nix}
    mount -o compress=zstd,subvol=home "$root_device" /mnt/home
    mount -o compress=zstd,noatime,subvol=nix "$root_device" /mnt/nix

    # Mount the EFI boot partition
    mkdir -p /mnt/boot
    mount "/dev/$part_boot" /mnt/boot
    # ----------------------------------------------------------

    # Stage configurations inside targeted file system tree
    mkdir -p /mnt/etc/nixos
    cp -r ./ /mnt/etc/nixos

    # Generate explicit hardware configuration out to file, filtering targeted exclusions
    info "Generating and filtering Hardware Profiles..."
    nixos-generate-config --root /mnt --show-hardware-config | grep -v -E "secrets|rclone" > /mnt/etc/nixos/hosts/default/hardware-configuration.nix

    # 3. Dynamic Values Injections (Handled safely on the target filesystem)
    if [ -f "/mnt/etc/nixos/hosts/default/variables.nix" ]; then
        sed -i -e "s/username = \".*\"/username = \"$username\"/" "/mnt/etc/nixos/hosts/default/variables.nix"
        sed -i -e "s/videoDriver = \".*\"/videoDriver = \"$driver\"/" "/mnt/etc/nixos/hosts/default/variables.nix"
    fi

    # Trigger deployment target evaluation with explicit experimental flags
    info "Executing main system installation bootstrap..."
    nixos-install --flake /mnt/etc/nixos#default --no-root-passwd --extra-experimental-features "nix-command flakes"

    # Set user runtime credentials safely inside target generation
    nixos-enter --root /mnt -c "echo '$password' | passwd --stdin $username"

    # Seed localized profile directories
    mkdir -p "/mnt/home/$username"/{Downloads,Documents,Pictures,Videos,NixOS}
    cp -r /mnt/etc/nixos "/mnt/home/$username/NixOS/"
    
    # Resolve safe POSIX namespace permissions targeting user account profile context
    uid=$(awk -F: -v user="$username" '$1 == user {print $3}' /mnt/etc/passwd)
    gid=$(awk -F: -v user="$username" '$1 == user {print $4}' /mnt/etc/passwd)
    chown -R "${uid:-$username}:${gid:-users}" "/mnt/home/$username"

    info "Installation complete! Please unmount or reboot safely to explore your system."

else
    # --- EXISTING INSTALLED SYSTEM ROUTINE ---
    
    # 3. Dynamic Values Injections for Installed Modifications
    if [ -f "./hosts/default/variables.nix" ]; then
        sed -i -e "s/username = \".*\"/username = \"$username\"/" "./hosts/default/variables.nix"
        sed -i -e "s/videoDriver = \".*\"/videoDriver = \"$driver\"/" "./hosts/default/variables.nix"
    fi

    info "Cleaning up conflicting native configuration files..."
    paths=(
        ~/.mozilla/firefox/profiles.ini
        ~/.zen/profiles.ini
        ~/.gtkrc-*
        ~/.config/gtk-*
        ~/.config/cava
    )
    for file in "${paths[@]}"; do
        for expanded in $file; do
            if [ -e "$expanded" ] && [ ! -L "$expanded" ]; then sudo rm -rf "$expanded"; fi
        done
    done

    # Synchronize native system hardware settings safely while discarding sensitive paths
    target_hardware="./hosts/default/hardware-configuration.nix"
    if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
        grep -v -E "secrets|rclone" "/etc/nixos/hardware-configuration.nix" | sudo tee "$target_hardware" >/dev/null
    else
        sudo nixos-generate-config --show-hardware-config | grep -v -E "secrets|rclone" | sudo tee "$target_hardware" >/dev/null
    fi

    sudo git -C . add hosts/default/hardware-configuration.nix || true

    info "Building and activating configuration changes..."
    if sudo nixos-rebuild switch --flake .#default --extra-experimental-features "nix-command flakes"; then
        info "System switched successfully!"
    else
        error "Nixos-rebuild failed. Review compilation output messages above."
        exit 1
    fi
fi

# 5. Shared Informational Output for Post-Installation Configuration Tasks
echo -e "\n${YELLOW}======================================================${NC}"
echo -e "${YELLOW}IMPORTANT POST-INSTALL NOTICE:${NC}"
echo -e "The installation script has completed successfully."
echo -e "Private sops configs, Git sign keys, and rclone connections were skipped."
echo -e "You can configure your custom secrets setup manually at your leisure."
echo -e "${YELLOW}======================================================${NC}\n"