{pkgs, ...}: 

{
  # 1. Enable greetd (the modern backend manager daemon)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # This tells greetd to boot the user 'greeter' directly into the ReGreet binary
        command = "${pkgs.cage}/bin/cage -s -- ${pkgs.regreet}/bin/regreet";
        user = "greeter";
      };
    };
  };

  # 2. Enable and configure the Rust-based ReGreet UI interface
  programs.regreet = {
    enable = true;

    # Explicitly map your custom global OLED styling assets
    theme = {
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme;
    };

    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };

    # ReGreet's TOML structural blocks configuration
    settings = {
      greeter = {
        remember_user = true;
        default_session = "niri";
      };
      # Sets up standard system preferences
      background = {
        # Fits a solid flat black wall space behind the container layout
        path = "/etc/greetd/nix.png";
        fit = "Cover"; # Options: "Cover", "Contain", "Fill", "Tile", "ScaleDown"
      };

      GTK = {
        # Enforces your global application preference variables
        application_prefer_dark_theme = true;
      };
    };
  };

  # 4. Set your default target session workspace environment variables globally
  services.displayManager = {
    defaultSession = "niri";
  };
}

