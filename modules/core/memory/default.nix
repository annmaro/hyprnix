{ config, lib, pkgs, ... }:

{
  # 1. Swap/zRAM Configuration (highly recommended for systemd-oomd)
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
  };

  # 2. Modern Systemd-OOMD Configuration
  systemd.oomd = {
    enable = true;
    enableUserSlices = true; # Automatically applies OOM tracking to user processes
  };

  # 3. Configure user.slice to tolerate 90% pressure before killing anything
  systemd.slices."user" = {
    sliceConfig = {
      ManagedOOMMemoryPressure = "kill";
      ManagedOOMMemoryPressureLimit = "90%";
    };
  };
}