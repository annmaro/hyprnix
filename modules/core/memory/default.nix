{ config, lib, pkgs, ... }:

{
  # 1. zRAM Configuration (Compressed RAM Swap)
  zramSwap = {
    enable = true;
    # 50% dynamically allocates exactly 8GB on your 16GB system
    memoryPercent = 50;
    
    # Explicitly set the compression algorithm. 'zstd' is the modern standard 
    # for a great balance of speed and compression ratio.
    algorithm = "zstd"; 
  };

  # 2. Out-Of-Memory (OOM) Daemon
  # Prevents hard system freezes by killing memory hogs before RAM completely runs out
  services.earlyoom = {
    enable = true;
    # Kills the largest unessential process when free RAM drops to 5%
    freeMemThreshold = 5; 
  };
}