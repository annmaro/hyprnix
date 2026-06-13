{ pkgs, ... }:

{
  boot.kernelParams = [
    "intel_pstate=active"
    "i915.enable_guc=3" # Modern flag to force enable GuC/HuC firmware loading
    "i915.enable_psr=1" # Panel Self Refresh for power savings
    "mem_sleep_default=deep" # Allow deepest sleep states
    "nvme.noacpi=1" # Helps with NVME power consumption
  ];

  # Load the driver
  services.xserver.videoDrivers = [ "modesetting" ];

  # Graphics / Hardware Acceleration (VA-API)
  hardware.graphics = {
    enable = true; # Explicitly ensure graphics are enabled
    enable32Bit = true; # Required for certain 32-bit driver dependencies
    extraPackages = with pkgs; [
      intel-media-driver # The correct, high-performance driver for UHD 620

      # OpenCL support for computing tasks (optional, but good for applications like Blender or Darktable)
      intel-compute-runtime
    ];
  };

  # Thermal and Noise Management
  services.thermald.enable = true;
  services.throttled.enable = false; # Keep if resolving laptop-specific throttling bugs
}
