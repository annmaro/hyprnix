{ pkgs, ... }:

{
  # 1. Enable greetd (the modern backend manager daemon)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.cage}/bin/cage -s -- ${pkgs.regreet}/bin/regreet";
        user = "greeter";
      };
    };
  };

  # 2. Fix the "Remember Me" permission constraint
  # Greetd runs as the isolated 'greeter' user. It needs explicit write access to its 
  # home cache folder to store your last session choice and username.
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

    # ReGreet's TOML structural blocks configuration
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
    }; # <--- settings ENDS HERE CLEANLY NOW

    # 4. FIXED: extraCss is now a first-class native attribute of programs.regreet!
    extraCss = ''
      /* FORCE THE MAIN BACKGROUND LAYOUT TO PITCH BLACK */
      window, box, stack, grid {
          background-color: #000000 !important;
      }

      /* SHRINK & MOVE THE MAIN LOGIN BOX CONTAINER */
      /* ReGreet wraps its login panel elements inside a generic container classed as .main-box */
      .main-box, window > box, grid > box {
          max-width: 360px !important;
          min-width: 360px !important;
          
          /* Force centering vertically, but anchor hard to the left side with 100px padding */
          margin: auto auto auto 100px !important; 
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

  # 5. Set your default target session workspace environment variables globally
  services.displayManager = {
    defaultSession = "niri";
  };
}