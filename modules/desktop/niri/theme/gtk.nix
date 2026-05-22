{ pkgs, ... }:

let
  variant = "mocha";
  accent = "mauve";
  catppuccin-theme-name = "catppuccin-${variant}-${accent}";
in
{
  # Install the theme packages globally at the system level
  environment.systemPackages = with pkgs; [
    papirus-icon-theme
    bibata-cursors
    catppuccin-gtk
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
          name = "${catppuccin-theme-name}-compact";
          package = pkgs.catppuccin-gtk.override {
            inherit variant;
            accents = [ accent ];
            size = "compact";
          };
        };
        iconTheme = {
          package = pkgs.papirus-icon-theme;
          name = "Papirus-Dark";
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

      # Direct injection for modern GTK4 themes to read Catppuccin assets
      xdg.configFile = {
        "gtk-4.0/assets" = {
          force = true;
          source = "${pkgs.catppuccin-gtk.override { inherit variant; accents = [ accent ]; size = "compact"; }}/share/themes/${catppuccin-theme-name}-compact/gtk-4.0/assets";
        };
        "gtk-4.0/gtk.css" = {
          force = true;
          source = "${pkgs.catppuccin-gtk.override { inherit variant; accents = [ accent ]; size = "compact"; }}/share/themes/${catppuccin-theme-name}-compact/gtk-4.0/gtk.css";
        };
        "gtk-4.0/gtk-dark.css" = {
          force = true;
          source = "${pkgs.catppuccin-gtk.override { inherit variant; accents = [ accent ]; size = "compact"; }}/share/themes/${catppuccin-theme-name}-compact/gtk-4.0/gtk-dark.css";
        };
      };
    })
  ];
}