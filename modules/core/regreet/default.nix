{
  config,
  pkgs,
  ...
}: let
  # 1. Create a minimal, dedicated Niri configuration layer for greetd
  niriGreeterConfig = pkgs.writeText "niri-greeter-config.kdl" ''
    // Fire ReGreet automatically upon Niri initialization
    spawn-at-startup "${pkgs.regreet}/bin/regreet"

    // Target the window layer namespace that ReGreet renders onto
    layer-rule {
        match namespace="regreet"

        // Render 20px hardware-accelerated Gaussian Blur behind transparency
        blur radius=20 optimize-for-asymmetrical-blur=true
    }

    window-rule {
        geometry-corner-radius 12
    }
  '';
in {
  # Ensure Niri is natively compiled and system architectures are ready
  programs.niri.enable = true;

  # 2. Configure the greetd display daemon
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Hook Niri to handle the hardware layer canvas with our explicit config
        command = "${pkgs.niri}/bin/niri --config ${niriGreeterConfig}";
        user = "greeter";
      };
    };
  };

  # 3. Configure and style the ReGreet interface
  programs.regreet = {
    enable = true;

    settings = {
      background = {
        path = "/etc/nix.png"; # Ensure your physical image file is at this path
        fit = "Cover";
      };
      GTK = {
        theme_name = "Gruvbox-Dark";
      };
    };

    # Custom GTK4 CSS Injection Layer
    extraCss = ''
      /* Make the top-level main application container transparent */
      window, .main-window {
          background-color: transparent !important;
      }

      /* Force GTK's top layout wrapper to align everything to the left side */
      main > box {
          halign: start !important;
          valign: center !important;
      }

      /* Style and position the shifted login card */
      #container, .card, .login-box, box.vertical {
          /* Semi-transparent slate theme */
          background-color: rgba(20, 20, 20, 0.45) !important;
          border: 1px solid rgba(255, 255, 255, 0.15) !important;
          border-radius: 16px !important;
          box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5) !important;

          /* Generous padding inside the card */
          padding: 35px !important;

          /* Push it away from the extreme left monitor edge for aesthetic balance */
          margin-left: 100px !important;

          /* Fix a reliable width constraint for the login card layout */
          min-width: 360px !important;
      }

      /* Stylize input boxes inside the card frame */
      entry {
          background-color: rgba(255, 255, 255, 0.07) !important;
          color: #ffffff !important;
          border: 1px solid rgba(255, 255, 255, 0.1) !important;
          border-radius: 8px !important;
          padding: 10px !important;
      }

      entry:focus {
          border-color: rgba(255, 255, 255, 0.45) !important;
          background-color: rgba(255, 255, 255, 0.12) !important;
      }

      /* Fix text contrast labels for the dark theme */
      label {
          color: #e5e5e5 !important;
          font-weight: 500;
      }
    '';
  };
}
