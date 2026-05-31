{ pkgs, ... }:

let
  # Import your theme token values directly into this file
  amoledTheme = import ../dms/dms_theme.nix { inherit pkgs; };
  # Extract the specific background/surface/accent tokens from your flavor
  bg = (builtins.elemAt amoledTheme.variants.flavors 0).dark.background; # "#000000"
  accent = (builtins.elemAt amoledTheme.variants.accents 11).black.primary; # "#fabd2f" (Yellow)
  text = (builtins.elemAt amoledTheme.variants.flavors 0).dark.backgroundText; # "#FFFFFF"
in
{
  # Install the theme packages globally at the system level
  environment.systemPackages = with pkgs; [
    gruvbox-plus-icons
    bibata-cursors
    adw-gtk3
  ];

  # Force native Wayland applications to recognize the cursor size and style
  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  # Configure User-Level Theme Engines via Home Manager
  home-manager.sharedModules = [
    (_: {
      # Sets the cursor style for both native GTK and legacy XWayland windows
      home.pointerCursor = {
        enable = true;
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };

      # Sets up standard GTK theme variables across environments
      gtk = {
        enable = true;
        gtk2.force = true;
        theme = {
          name = "adw-gtk3-dark";
          package = pkgs.adw-gtk3;
        };
        iconTheme = {
          package = pkgs.gruvbox-plus-icons;
          name = "Gruvbox-Plus-Dark-Yellow";
        };
        gtk3.extraConfig = {
          "gtk-application-prefer-dark-theme" = "1";
        };
        gtk4.extraConfig = {
          "gtk-application-prefer-dark-theme" = "1";
        };
        gtk4.theme = null;
      };

      # Enforce dark theme across Libadwaita applications natively
      home.sessionVariables = {
        ADW_COLOR_SCHEME = "prefer-dark";
      };

      # Enforce dark theme parameters inside the system dconf database
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };

      # Generate the custom index.theme file for your Folder/Icon theme
      home.file = {
        # index file for the icon theme, placed in the user's local icon directory
        ".local/share/icons/Gruvbox-Plus-Dark-Yellow/index.theme" = {
          text = ''
            [Icon Theme]
            Name=Gruvbox-Plus-Dark-Yellow
            Comment=Gruvbox Plus Dark Icon Theme with Custom Yellow Folders
            Inherits=Gruvbox Plus Dark

            Directories=places/scalable,places/16,places/22,places/24,places/32,places/48,places/64

            [places/scalable]
            Size=64
            Context=Places
            Type=Scalable
            MinSize=16
            MaxSize=512

            [places/16]
            Size=16
            Context=Places
            Type=Fixed

            [places/22]
            Size=22
            Context=Places
            Type=Fixed

            [places/24]
            Size=24
            Context=Places
            Type=Fixed

            [places/32]
            Size=32
            Context=Places
            Type=Fixed

            [places/48]
            Size=48
            Context=Places
            Type=Fixed

            [places/64]
            Size=64
            Context=Places
            Type=Fixed
          '';
        };

        # Dynamically write out GTK 4 colors using your theme file values
        ".local/share/icons/Gruvbox-Plus-Dark-Yellow/places/scalable".source = ./custom-icons/places/scalable;
        ".local/share/icons/Gruvbox-Plus-Dark-Yellow/places/16".source = ./custom-icons/places/scalable;
        ".local/share/icons/Gruvbox-Plus-Dark-Yellow/places/22".source = ./custom-icons/places/scalable;
        ".local/share/icons/Gruvbox-Plus-Dark-Yellow/places/24".source = ./custom-icons/places/scalable;
        ".local/share/icons/Gruvbox-Plus-Dark-Yellow/places/32".source = ./custom-icons/places/scalable;
        ".local/share/icons/Gruvbox-Plus-Dark-Yellow/places/48".source = ./custom-icons/places/scalable;
        ".local/share/icons/Gruvbox-Plus-Dark-Yellow/places/64".source = ./custom-icons/places/scalable;
      };

      # Hard injection for GTK configurations to re-tint the base workspace container elements to black
      xdg.configFile = {
        # Dynamically write out GTK 4 colors using your theme file values
        "gtk-4.0/gtk-dark.css".text = ''
          @define-color window_bg_color ${bg};
          @define-color view_bg_color ${bg};
          @define-color headerbar_bg_color #050505;
          @define-color accent_color ${accent};
          @define-color accent_bg_color ${accent};
          @define-color theme_fg_color ${text};
        '';

        # Dynamically write out GTK 3 legacy overrides
        "gtk-3.0/gtk.css".text = ''
          @define-color theme_bg_color ${bg};
          @define-color theme_base_color ${bg};
          @define-color theme_selected_bg_color ${accent};

          .thunar window, .thunar .background {
              background-color: ${bg};
          }
        '';
      };
    })
  ];
}
