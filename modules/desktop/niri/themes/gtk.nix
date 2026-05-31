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

      home.file.".local/share/icons/Gruvbox-Plus-Dark/places/scalable" = {
        # This points to your folder containing ONLY the modified yellow SVGs
        source = ./custom-icons/places/scalable;
        recursive = true;
      };

      # Generate the custom index.theme file for your Folder/Icon theme
      home.file.".local/share/icons/Gruvbox-Plus-Dark/index.theme".text = ''
        [Icon Theme]
        Name=Gruvbox-Plus-Dark
        Comment=Gruvbox Plus Dark Icon Theme with Custom Yellow Folders
        Inherits=Adwaita,breeze,hicolor

        # Example directories mapping (adjust based on your theme's layout)
        Directories=places/scalable

        [places/scalable]
        Size=64
        Context=Places
        Type=Scalable
        MinSize=16
        MaxSize=512
      '';

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
