{ pkgs, ... }:

let
  gruvbox-theme-name = "Gruvbox-Dark";
in
{
  # Install the theme packages globally at the system level
  environment.systemPackages = with pkgs; [
    gruvbox-plus-icons
    bibata-cursors
    gruvbox-gtk-theme
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
          name = "${gruvbox-theme-name}";
          package = pkgs.gruvbox-gtk-theme;
        };
        iconTheme = {
          package = pkgs.gruvbox-plus-icons;
          name = "Gruvbox-Plus-Dark";
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
        ".local/share/icons/Gruvbox-Plus-Dark/index.theme" = {
          text = ''
            [Icon Theme]
            Name=Gruvbox-Plus-Dark
            Comment=Gruvbox Plus Dark Icon Theme with Custom Yellow Folders
            Inherits=Adwaita,breeze,hicolor

            Directories=places/scalable

            [places/scalable]
            Size=64
            Context=Places
            Type=Scalable
            MinSize=16
            MaxSize=512
          '';
        };
        # Custom folder icons to override the default ones in the places/scalable directory of the icon theme
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder.svg".source =
          ./custom-icons/places/scalable/folder.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-documents.svg".source =
          ./custom-icons/places/scalable/folder-documents.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-documents-open.svg".source =
          ./custom-icons/places/scalable/folder-documents-open.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-downloads.svg".source =
          ./custom-icons/places/scalable/folder-downloads.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-downloads-open.svg".source =
          ./custom-icons/places/scalable/folder-downloads-open.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-desktop.svg".source =
          ./custom-icons/places/scalable/folder-desktop.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-home.svg".source =
          ./custom-icons/places/scalable/folder-home.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-home-open.svg".source =
          ./custom-icons/places/scalable/folder-home-open.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-music.svg".source =
          ./custom-icons/places/scalable/folder-music.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-music-open.svg".source =
          ./custom-icons/places/scalable/folder-music-open.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-pictures.svg".source =
          ./custom-icons/places/scalable/folder-pictures.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-pictures-open.svg".source =
          ./custom-icons/places/scalable/folder-pictures-open.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-videos.svg".source =
          ./custom-icons/places/scalable/folder-videos.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-videos-open.svg".source =
          ./custom-icons/places/scalable/folder-videos-open.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-publicshare.svg".source =
          ./custom-icons/places/scalable/folder-publicshare.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-publicshare-open.svg".source =
          ./custom-icons/places/scalable/folder-publicshare-open.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-hdd.svg".source =
          ./custom-icons/places/scalable/folder-hdd.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-hdd-open.svg".source =
          ./custom-icons/places/scalable/folder-hdd-open.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-network.svg".source =
          ./custom-icons/places/scalable/folder-network.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-icons.svg".source =
          ./custom-icons/places/scalable/folder-icons.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-favorites.svg".source =
          ./custom-icons/places/scalable/folder-favorites.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-search.svg".source =
          ./custom-icons/places/scalable/folder-search.svg;
        ".local/share/icons/Gruvbox-Plus-Dark/places/scalable/folder-icons.svg".source =
          ./custom-icons/places/scalable/folder-icons.svg;
      };

      # Hard injection for GTK configurations to re-tint the base workspace container elements to black
      xdg.configFile = {
        "gtk-4.0/assets" = {
          force = true;
          source = "${pkgs.gruvbox-gtk-theme}/share/themes/${gruvbox-theme-name}/gtk-4.0/assets";
        };
        "gtk-4.0/gtk.css" = {
          force = true;
          source = "${pkgs.gruvbox-gtk-theme}/share/themes/${gruvbox-theme-name}/gtk-4.0/gtk.css";
        };

        # Custom overrides directly over the default dark definitions to create an OLED layout
        "gtk-4.0/gtk-dark.css".text = ''
          @import url("${pkgs.gruvbox-gtk-theme}/share/themes/${gruvbox-theme-name}/gtk-4.0/gtk-dark.css");

          /* Brute force window elements and client side headers into #000000 */
          window, .background, messagebox, dialog {
              background-color: #000000;
          }

          /* Darken header bars and internal content layout dividers */
          headerbar, .titlebar {
              background-color: #050505;
              box-shadow: none;
          }
        '';

        # Hard injection added for GTK3 to force flat black on legacy window interfaces
        "gtk-3.0/gtk.css".text = ''
           @import url("${pkgs.gruvbox-gtk-theme}/share/themes/${gruvbox-theme-name}/gtk-3.0/gtk.css");

           /* Brute force window elements and client side headers into #000000 */
          /* Force Thunar's framework wrapper elements into flat black */
          .thunar, 
          .thunar window, 
          .thunar .background, 
          ThunarWindow {
              background-color: #000000;
              background-image: none;
          }

          /* Strip color layers off the sidebar panel and standard view grids */
          .thunar .sidebar,
          .thunar .sidebar treeview,
          .thunar .standard-view,
          .thunar .standard-view .view,
          .thunar scrolledwindow {
              background-color: #000000;
              background-image: none;
          }

          /* Match the top location and navigation toolbars */
          headerbar, .titlebar, .thunar .toolbar, .thunar toolbar {
              background-color: #050505;
              background-image: none;
              box-shadow: none;
          }
        '';
      };
    })
  ];
}
