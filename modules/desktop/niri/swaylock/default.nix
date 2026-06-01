{ pkgs, ... }:

{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {

        # 1. Configure Swaylock / Swaylock-effects
        programs.swaylock = {
          enable = true;
          # Force home-manager to use the swaylock-effects package for blur features
          package = pkgs.swaylock-effects;

          settings = {
            # Stylix automatically colors the background/indicator, but you can pass extra
            # swaylock-effects arguments here:
            screenshots = true;
            clock = true;
            indicator = true;
            indicator-radius = 100;
            indicator-thickness = 7;
            effect-blur = "7x5"; # Smooth blur effect for behind the lock screen
            effect-vignette = "0.5:0.5";
          };
        };

        # 2. Configure Swayidle (Idling daemon for Niri)
        services.swayidle = {
          enable = true;
          events = [
            # Lock the screen before the system goes to sleep
            {
              event = "before-sleep";
              command = "${pkgs.swaylock-effects}/bin/swaylock -f";
            }
          ];
          timeouts = [
            # Timeout 1: Lock the screen after 5 minutes of inactivity
            {
              timeout = 300;
              command = "${pkgs.swaylock-effects}/bin/swaylock -f";
            }
            # Timeout 2: Turn off the displays via Niri 2 minutes after locking
            {
              timeout = 420;
              command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
              # Turn screens back on when activity is detected
              resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
            }
          ];
        };

        # 3. Ensure Stylix styles them automatically
        stylix.targets = {
          swaylock.enable = true; # Tells Stylix to inject the colors into the locker lock ring
        };

      }
    )
  ];
}
