{ lib, ... }:
{
  # change according to your partition name and format
  fileSystems."/mnt/Data" = lib.mkForce {
    device = "/dev/disk/by-uuid/fcd8693d-39c7-49cc-a9de-c18d15f2d69d";
    fsType = "btrfs";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "noatime"
      "umask=000"
      "nofail"
      "x-gvfs-show"
      "x-systemd.mount-timeout=5"
    ];
  };
}
