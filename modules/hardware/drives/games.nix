{ lib, ... }:
{
  # change according to your partition name and format
  fileSystems."/mnt/Data" = lib.mkForce {
    device = "/dev/disk/by-uuid/fcd8693d-39c7-49cc-a9de-c18d15f2d69d";
    fsType = "btrfs";
    options = [
      "rw"
      "defaults" # Default flags
      "async" # Run all operations async
      "noatime"
      "nofail"
      "x-gvfs-show"
      "x-systemd.mount-timeout=5"
    ];
  };
}
