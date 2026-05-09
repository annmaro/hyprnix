{ lib, ... }:
{
  # change according to your partition name and format
  fileSystems."/mnt/entertainment" = lib.mkForce {
    device = "/dev/disk/by-uuid/1f018bd5-9915-4aa5-8061-024081929247";
    fsType = "btrfs";
    options = [
      "defaults" # Default flags
      "async" # Run all operations async
      "nofail" # Don't error if not plugged in
      "x-gvfs-show" # Show in file explorer
      "x-systemd.mount-timeout=5" # Timout for error
      "X-mount.mkdir" # Make dir if it doesn't exist
    ];
  };
}
