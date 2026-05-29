{ pkgs, ... }:

{
  # 1. FIXED: Creating a localized, inline configuration file for Greetd's Niri session
  # This writes the .kdl file automatically with the proper cleanup command!
  environment.etc."greetd/niri.kdl".text = ''
    // Spawn regreet using shell execution and cleanly quit niri on exit
    spawn-sh-at-startup "regreet; niri msg action quit --skip-confirmation"

    window-rule {
        geometry-max-width "100%"
        geometry-max-height "100%"
        border-max-width 0
        box-shadow-max-width 0
    }

    layout {
        background-color "#000000"
    }
  '';

  # 2. FIXED: Point greetd directly to our generated etc path
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.niri}/bin/niri -c /etc/greetd/niri.kdl";
        user = "greeter";
      };
    };
  };

  # 3. ReGreet persistent tracking paths
  systemd.tmpfiles.rules = [
    "d /var/log/regreet 0755 greeter greeter - -"
    "d /var/lib/regreet 0755 greeter greeter - -"
  ];

  # 4. Configure ReGreet natively
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

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
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

    # 5. FIXED GTK4 CSS POSITIONAL SYSTEM
    extraCss = ''
      /* Force display container canvas layer to solid pitch black */
      window, .background {
          background-color: #000000 !important;
      }

      /* SHRINK & LEFT-ALIGN LOGIN CONTENT BOX */
      grid {
          max-width: 380px !important;
          min-width: 380px !important;

          position: absolute !important;
          top: 50% !important;
          left: 100px !important;
          transform: translateY(-50%) !important;
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

  # 6. Global session fallback definition
  services.displayManager = {
    defaultSession = "niri";
  };
}
