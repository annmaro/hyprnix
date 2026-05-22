{ pkgs, ... }: 

{

  # Enable the Feral Interactive GameMode Daemon
  programs.gamemode = {
    enable = true;

    # Declarative configuration for gamemode.ini
    settings = {
      general = {
        renice = 10;                # Sets nice priority of the game to -10 (high priority)
        ioprio = 0;                 # Gives games the highest I/O scheduling priority
        inhibit_screensaver = 1;    # Stops screensavers or monitors turning off while playing
      };

      # Optimizations for standard Linux CPU governors
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations activated. Performance governor engaged.'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations deactivated. Balanced governor restored.'";
      };

      # Optional GPU Optimizations (Uncomment if using a dedicated graphics card)
      # gpu = {
      #   apply_gpu_optimisations = "accept-responsibility";
      #   gpu_vendor = "amd"; # Choose: amd or nvidia
      #   amd_performance_level = "high";
      #   nv_core_clock_mhz_offset = 100;
      #   nv_mem_clock_mhz_offset = 100;
      # };
    };
  };

  # Ensure your login user is automatically allowed into the real-time scheduling group
  users.users.annmaro.extraGroups = [ "gamemode" ]; # Make sure to change 'yourusername' to yours
}