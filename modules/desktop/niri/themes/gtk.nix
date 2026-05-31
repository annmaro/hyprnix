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
          /* Remove spaces before !important for GTK parser compliance */
           window, .background, messagebox, dialog, 
           #thunar-window, 
           .thunar-window,
           ThunarWindow {
               background-color: #000000;
           }

           /* Target Thunar's side pane and main grid view */
           #thunar-window GtkPaned,
           #thunar-window GtkScrolledWindow,
           #thunar-window GtkTreeView,
           #thunar-window ExoIconView,
           #thunar-window .view {
               background-color: #000000;
           }

           /* Ensure headers and path bars match your styling */
           headerbar, .titlebar, ThunarWindow .toolbar {
               background-color: #050505;
               box-shadow: none;
           }
        '';
      };
    })
  ];
}
