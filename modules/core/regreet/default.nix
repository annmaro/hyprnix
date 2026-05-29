{ pkgs, ... }:

{
  # 1. FIX: Setup the local cache path and tell greetd to explicitly read the Nix-generated config file
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # -c tells regreet exactly where NixOS puts its configuration file!
        command = "${pkgs.cage}/bin/cage -s -- ${pkgs.regreet}/bin/regreet -c /etc/greetd/regreet.toml";
        user = "greeter";
      };
    };
  };

  # 2. FIX: Persist cache so "Remember User & Session" works perfectly across reboots
  systemd.tmpfiles.rules = [
    "d /var/cache/regreet 0755 greeter greeter -"
  ];

  # 3. Enable and configure the Rust-based ReGreet UI interface
  programs.regreet = {
    enable = true;

    theme = {
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme;
    };

    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };

    settings = {
      greeter = {
        remember_user = true;
        default_session = "niri";
      };
      background = {
        path = "/etc/greetd/nix.png";
        fit = "Cover";
      };
      GTK = {
        application_prefer_dark_theme = true;
      };
    };

    # 4. FIX: Correct the container naming selectors for GTK4 window management layouts
    extraCss = ''
      /* Force display canvas to pure black */
      window {
          background-color: #000000 !important;
      }

      /* TARGET THE MAIN WINDOW WRAPPER LAYER */
      /* ReGreet aligns its login card elements inside a primary widget container named 'mainwindow' */
      #mainwindow {
          background-color: transparent !important;
          max-width: 380px !important;
          min-width: 380px !important;
          
          /* Pull to the left side with 100px padding, center vertically */
          margin: auto auto auto 100px !important;
      }

      /* Ensure inner layers don't overwrite centering constraints */
      #mainwindow > box, grid, stack {
          background-color: transparent !important;
      }

      /* CREDENTIAL FIELD STYLING */
      entry {
          background-color: #050505 !important;
          border: 1px solid #282828 !important;
          color: #ebdbb2 !important;
          border-radius: 4px;
          padding: 8px !important;
      }
      entry:focus {
          border-color: #fabd2f !important;
      }

      /* BUTTON STYLING */
      button {
          background-color: #141615 !important;
          color: #ebdbb2 !important;
          border-radius: 4px;
          padding: 6px 12px !important;
      }
      button:hover {
          background-color: #b8bb26 !important;
          color: #282828 !important;
      }
    '';
  };

  services.displayManager = {
    defaultSession = "niri";
  };
}