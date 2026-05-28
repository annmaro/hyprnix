{
  pkgs,
  ...
}:

{
  
  # 1. Install web-greeter so it's available globally on the system
  environment.systemPackages = [
    pkgs.web-greeter
  ];

  # 2. Configure LightDM to use JezerM/web-greeter
  services.displayManager = {
    defaultSession = "niri";
    
    lightdm = {
      enable = true;
      greeter = {
        package = pkgs.web-greeter;
        name = "web-greeter";
      };
    };
  };

  # 3. Create the web-greeter configuration file natively via Nix
  # This sets the theme globally to the bundled 'gruvbox' theme
  environment.etc."lightdm/web-greeter.toml".text = ''
    [greeter]
    # The default theme to use. web-greeter includes 'gruvbox' by default.
    theme = "gruvbox"

    # Screen setting
    screen_timeout = 60

    [commands]
    # Keep reboot and poweroff working cleanly with systemd
    reboot = "systemctl reboot"
    poweroff = "systemctl poweroff"
    suspend = "systemctl suspend"
    hibernate = "systemctl hibernate"
  '';
}