{
  pkgs,
  ...
}:

{
  
  # 1. Enable greetd (the modern backend manager daemon)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # This tells greetd to boot the user 'greeter' directly into the ReGreet binary
        command = "${pkgs.regreet}/bin/regreet";
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

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };

    # ReGreet's TOML structural blocks configuration
    settings = {
      # Sets up standard system preferences
      background = {
        # Fits a solid flat black wall space behind the container layout
        path = ""; 
        fit = "Contain";
      };
      
      GTK = {
        # Enforces your global application preference variables
        application_prefer_dark_theme = true;
      };
    };

    # 3. Inject custom CSS properties to force the OLED layout
    # ReGreet is written with pure GTK4 widgets, so we can target them natively!
    extraCss = ''
      /* Force the main login container layout to pitch black */
      window, box, stack, grid {
          background-color: #000000 !important;
      }

      /* Style the central login credential fields */
      entry {
          background-color: #050505 !important;
          border: 1px solid #282828 !important;
          color: #ebdbb2 !important;
          border-radius: 4px;
      }

      /* Accent input box highlight on active focus click */
      entry:focus {
          border-color: #fabd2f !important;
      }

      /* Clean styling adjustments for button interactive states */
      button {
          background-color: #141615 !important;
          color: #ebdbb2 !important;
          border-radius: 4px;
      }
      button:hover {
          background-color: #b8bb26 !important;
          color: #282828 !important;
      }
    '';
  };

  # 4. Set your default target session workspace environment variables globally
  services.displayManager = {
    defaultSession = "niri";
  };
}