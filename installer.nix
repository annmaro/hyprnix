{ self, pkgs }:

pkgs.writeShellScriptBin "installer" ''
  set -e

  # Colors for clean terminal output
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BLUE='\033[0;34m'
  NC='\033[0m'

  info() { echo -e "\n''${GREEN}$1''${NC}"; }
  warn() { echo -e "''${YELLOW}$1''${NC}"; }
  error() { echo -e "''${RED}Error: $1''${NC}" >&2; }

  echo -e "''${BLUE}=====================================================''${NC}"
  echo -e "''${BLUE}    Welcome to the Unified NixOS Flake Installer     ''${NC}"
  echo -e "''${BLUE}=====================================================''${NC}"

  # 1. Determine Environment
  IS_LIVE_ISO=false
  if [ -d "/iso" ] || [ "$(${pkgs.util-linux}/bin/findmnt -o FSTYPE -n /)" = "tmpfs" ]; then
      IS_LIVE_ISO=true
      info "Environment Detected: NixOS Live ISO Installation"
  else
      info "Environment Detected: Installed NixOS System Modification"
  fi

  # --- AUTO-WRAPPER ENVIRONMENT BOOTSTRAP ---
  if $IS_LIVE_ISO && [ -z "$NIX_FLAGS_ENFORCED" ]; then
      info "Enabling Flake features and preparing environment tools..."
      export NIX_FLAGS_ENFORCED=1
      exec nix shell nixpkgs#git nixpkgs#pciutils --extra-experimental-features "nix-command flakes" -c sudo -E "$0" "$@"
      exit $?
  fi

  # Privilege validations depending on execution context
  if $IS_LIVE_ISO; then
      if [ "$(id -u)" != "0" ]; then
          error "When running on a Live ISO, this script must be run as root."
          exit 1
      fi
  else
      if [ "$EUID" -eq 0 ]; then
          error "On an installed system, do not run this script directly as root/sudo! Run it as a normal user."
          exit 1
      fi
  fi

  if [ ! "$(grep -i nixos </etc/os-release)" ]; then
      error "This installation script only works on NixOS!"
      exit 1
  fi

  currentUser=$(logname 2>/dev/null || echo "$USER")

  # 2. Universal Interactive Prompts
  info "Configuration Setup:"

  # Username prompt
  while true; do
      read -rp "Enter desired username [default: $currentUser]: " username
      username=''${username:-$currentUser}
      if [[ "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then break; fi
      error "Invalid username format. Use lowercase letters, numbers, underscores, or hyphens."
  done

  # Hostname prompt
  read -rp "Enter desired system hostname [default: nixos]: " hostname
  hostname=''${hostname:-nixos}

  # Git credentials prompt
  read -rp "Enter your Git Username (e.g., John Doe) [default: $username]: " git_username
  git_username=''${git_username:-$username}

  read -rp "Enter your Git Email (e.g., john@example.com): " git_email
  git_email=''${git_email:-""}

  # Password prompt
  while true; do
      read -rsp "Enter password for $username: " password;
      echo ""
      read -rsp "Confirm password: " password_confirm;
      echo ""
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

  # Build resource limits
  echo ""
  info "System Build Resource Limits (Optional)"
  warn "Setting these limits can prevent out-of-memory crashes on low-RAM VMs."
  read -rp "Enter max parallel build jobs (e.g., 2, leave blank for default): " max_jobs
  read -rp "Enter max cores per job (e.g., 2, leave blank for default): " max_cores

  build_flags=""
  if [ -n "$max_jobs" ]; then build_flags="$build_flags --max-jobs $max_jobs"; fi
  if [ -n "$max_cores" ]; then build_flags="$build_flags --cores $max_cores"; fi

  # 4. Environment Branch Execution
  if $IS_LIVE_ISO; then
      # --- LIVE ISO ROUTINE ---
      info "Custom Partitions Routine"
      echo "Available partitions on your system:"
          lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINTS
          echo ""

          while true; do
              read -rp "Enter your existing EFI/Boot partition path (e.g., /dev/sdb1): " custom_efi
              if [ -b "$custom_efi" ]; then break; fi
              error "Invalid partition device."
          done

          while true; do
              read -rp "Enter your existing Root partition path (e.g., /dev/sdb2): " custom_root
              if [ -b "$custom_root" ]; then break; fi
              error "Invalid partition device."
          done

          echo -e "\n''${YELLOW}Formatting selected partitions...''${NC}"
          # Format Boot as VFAT
          mkfs.vfat -F 32 -n "BOOT" "$custom_efi"
          # Format Root as Btrfs
          mkfs.btrfs -f -L "root" "$custom_root"

          info "Mounting subvolumes manually..."
          mount "$custom_root" /mnt
          btrfs subvolume create /mnt/@
          btrfs subvolume create /mnt/@home
          btrfs subvolume create /mnt/@nix
          umount /mnt

          # Remount mapping layout precisely matching Disko standards
          mount -o compress=zstd,noatime,subvol=@ "$custom_root" /mnt
          mkdir -p /mnt/{boot,home,nix}
          mount -o compress=zstd,noatime,subvol=@home "$custom_root" /mnt/home
          mount -o compress=zstd,noatime,subvol=@nix "$custom_root" /mnt/nix
          mount -o umask=0077 "$custom_efi" /mnt/boot

      # --- SHARED INSTALL ENGINE ---
      # Rename the host directory and update flake if a custom hostname was provided
      if [ "$hostname" != "default" ]; then
          mv ./hosts/default ./hosts/"$hostname"
          sed -i -e "s/default = mkHost \"default\"/$hostname = mkHost \"$hostname\"/" ./flake.nix
      fi

      # Stage configurations inside targeted file system tree
      mkdir -p /mnt/etc/nixos
      cp -r ./ /mnt/etc/nixos

      # Generate explicit hardware configuration out to file, filtering targeted exclusions
      info "Generating and filtering Hardware Profiles..."
      nixos-generate-config --root /mnt --show-hardware-config | grep -v -E "secrets|rclone" > "/mnt/etc/nixos/hosts/$hostname/hardware-configuration.nix"

      # Dynamic Values Injections (Handled safely on the target filesystem)
      if [ -f "/mnt/etc/nixos/hosts/$hostname/variables.nix" ]; then
          sed -i -e "s/hostname = \".*\"/hostname = \"$hostname\"/" "/mnt/etc/nixos/hosts/$hostname/variables.nix"
          sed -i -e "s/username = \".*\"/username = \"$username\"/" "/mnt/etc/nixos/hosts/$hostname/variables.nix"
          sed -i -e "s/videoDriver = \".*\"/videoDriver = \"$driver\"/" "/mnt/etc/nixos/hosts/$hostname/variables.nix"
          sed -i -e "s/gitUsername = \".*\"/gitUsername = \"$git_username\"/" "/mnt/etc/nixos/hosts/$hostname/variables.nix"
          sed -i -e "s/gitEmail = \".*\"/gitEmail = \"$git_email\"/" "/mnt/etc/nixos/hosts/$hostname/variables.nix"
      fi

      # Trigger deployment target evaluation with explicit experimental flags
      info "Executing main system installation bootstrap..."
      NIX_CONFIG="extra-experimental-features = nix-command flakes" nixos-install --flake "/mnt/etc/nixos#$hostname" --no-root-passwd $build_flags

      # Set user runtime credentials safely inside target generation
      nixos-enter --root /mnt -c "echo '$password' | passwd --stdin $username"

      # Seed localized profile directories
      mkdir -p "/mnt/home/$username"/{Downloads,Documents,Pictures,Videos,NixOS}
      cp -r /mnt/etc/nixos "/mnt/home/$username/NixOS/"
      
      # Resolve safe POSIX namespace permissions targeting user account profile context
      uid=$(awk -F: -v user="$username" '$1 == user {print $3}' /mnt/etc/passwd)
      gid=$(awk -F: -v user="$username" '$1 == user {print $4}' /mnt/etc/passwd)
      chown -R "''${uid:-$username}''${gid:-:users}" "/mnt/home/$username"

      info "Installation complete! Please unmount or reboot safely to explore your system."

  else
      # --- EXISTING INSTALLED SYSTEM ROUTINE ---
      # Rename the host directory and update flake if a custom hostname was provided
      if [ "$hostname" != "default" ] && [ -d "./hosts/default" ]; then
          mv ./hosts/default ./hosts/"$hostname"
          sed -i -e "s/default = mkHost \"default\"/$hostname = mkHost \"$hostname\"/" ./flake.nix
      fi

      if [ -f "./hosts/$hostname/variables.nix" ]; then
          sed -i -e "s/hostname = \".*\"/hostname = \"$hostname\"/" "./hosts/$hostname/variables.nix"
          sed -i -e "s/username = \".*\"/username = \"$username\"/" "./hosts/$hostname/variables.nix"
          sed -i -e "s/videoDriver = \".*\"/videoDriver = \"$driver\"/" "./hosts/$hostname/variables.nix"
          sed -i -e "s/gitUsername = \".*\"/gitUsername = \"$git_username\"/" "./hosts/$hostname/variables.nix"
          sed -i -e "s/gitEmail = \".*\"/gitEmail = \"$git_email\"/" "./hosts/$hostname/variables.nix"
      fi

      info "Cleaning up conflicting native configuration files..."
      paths=(
          ~/.mozilla/firefox/profiles.ini
          ~/.zen/profiles.ini
          ~/.gtkrc-*
          ~/.config/gtk-*
          ~/.config/cava
      )
      for file in "''${paths[@]}"; do
          for expanded in $file; do
              if [ -e "$expanded" ] && [ ! -L "$expanded" ]; then sudo rm -rf "$expanded"; fi
          done
      done

      # Synchronize native system hardware settings safely while discarding sensitive paths
      target_hardware="./hosts/$hostname/hardware-configuration.nix"
      if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
          grep -v -E "secrets|rclone" "/etc/nixos/hardware-configuration.nix" | sudo tee "$target_hardware" >/dev/null
      else
          sudo nixos-generate-config --show-hardware-config | grep -v -E "secrets|rclone" | sudo tee "$target_hardware" >/dev/null
      fi

      sudo git -C . add "hosts/$hostname/hardware-configuration.nix" || true

      info "Building and activating configuration changes..."
      if sudo NIX_CONFIG="extra-experimental-features = nix-command flakes" nixos-rebuild switch --flake ".#$hostname" $build_flags; then
          info "System switched successfully!"
      else
          error "Nixos-rebuild failed. Review compilation output messages above."
          exit 1
      fi
  fi

  # 5. Shared Informational Output for Post-Installation Configuration Tasks
  echo -e "\n''${YELLOW}======================================================''${NC}"
  echo -e "''${YELLOW}IMPORTANT POST-INSTALL NOTICE:''${NC}"
  echo -e "The installation script has completed successfully."
  echo -e "Private sops configs, Git sign keys, and rclone connections were skipped."
  echo -e "You can configure your custom secrets setup manually at your leisure."
  echo -e "''${YELLOW}======================================================''${NC}\n"
''
