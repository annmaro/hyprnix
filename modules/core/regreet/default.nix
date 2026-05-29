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
      extraCss = ''
      /* 1. FORCE THE MAIN BACKGROUND LAYOUT TO PITCH BLACK */
      window, box, stack, grid {
          background-color: #000000 !important;
      }

      /* 2. SHRINK & MOVE THE MAIN LOGIN BOX CONTAINER */
      /* By default, this is a GTK stack or grid centered on your screen */
      window > box {
          /* Decrease the maximum width of the central UI column */
          max-width: 360px !important;

          /* --- CONTROLLING POSITION --- */
          /* Default centered: margin: auto !important; */
          
          /* OPTION A: To move it to the LEFT side of the screen */
          margin: auto auto auto 100px !important; 
          
          /* OPTION B: To move it to the RIGHT side of the screen */
          /* margin: auto 100px auto auto !important; */
      }

      /* 3. CREDENTIAL FIELD STYLING */
      entry {
          background-color: #050505 !important;
          border: 1px solid #282828 !important;
          color: #ebdbb2 !important;
          border-radius: 4px;
          padding: 8px !important; /* Makes the box look sharper when shrunk */
      }
      entry:focus {
          border-color: #fabd2f !important;
      }

      /* 4. BUTTON STYLING */
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
  };

  # 4. Set your default target session workspace environment variables globally
  services.displayManager = {
    defaultSession = "niri";
  };
}

