{ pkgs, ... }:

{
  # 1. FIXED: Overriding greetd to use a dedicated DBus-wrapped Wayland session
  # This points directly to the persistent custom /etc/greetd/niri.kdl layout file
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.niri}/bin/niri -c /etc/greetd/niri.kdl";
        user = "greeter";
      };
    };
  };

  # 2. ReGreet's persistent history paths
  systemd.tmpfiles.rules = [
    "d /var/log/regreet 0755 greeter greeter - -"
    "d /var/lib/regreet 0755 greeter greeter - -"
  ];

  # 3. Configure the ReGreet interface values natively
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

    # 4. FIXED PITCH-BLACK BOX LAYOUT:
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

  # 5. Global session target fallback definition
  services.displayManager = {
    defaultSession = "niri";
  };
}