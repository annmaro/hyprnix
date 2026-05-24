{ pkgs, ... }:
{
  boot = {
    # Filesystems support
    supportedFilesystems = [
      "ntfs"
      "exfat"
      "ext4"
      "fat32"
      "btrfs"
    ];
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_zen; # _latest, _zen, _xanmod_latest, _hardened, _rt, _OTHER_CHANNEL, etc.
    
    # Kernel Parameter Tuning for zRAM
    kernel.sysctl = {
      "vm.swappiness" = 100;
    };
    kernelParams = [
      "preempt=full" # lower latency but less throughput
    ];
    
    loader = {
      systemd-boot.enable = true;   
      systemd-boot.consoleMode = "auto"; # Automatically scales up the text/resolution
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
      timeout = 10; # bootloader display duration
      
      grub = {
        enable = false;
      };
    };
    
    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };
}
