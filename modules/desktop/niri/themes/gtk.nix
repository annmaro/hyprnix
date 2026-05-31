{ pkgs, ... }:

let
  gruvbox-theme-name = "Gruvbox-Dark";
in
{
  # 1. Keep the packages global and clean
  environment.systemPackages = with pkgs; [
    gruvbox-plus-icons
    bibata-cursors
    gruvbox-gtk-theme
  ];

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  home-manager.sharedModules = [
    (_: {
      home.pointerCursor = {
        enable = true;
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };

      gtk = {
        enable = true;
        gtk2.force = true;
        theme = {
          name = "${gruvbox-theme-name}";
          package = pkgs.gruvbox-gtk-theme;
        };
        # 2. Reset the icon theme back to the standard dark layout
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

      home.sessionVariables = {
        ADW_COLOR_SCHEME = "prefer-dark";
      };
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };

      # 3. Intercept the standard folder assets inside your user profile
      xdg.dataFile = {
        "icons/Gruvbox-Plus-Dark/places/16".source =
          "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark/places/16-yellow";
        "icons/Gruvbox-Plus-Dark/places/22".source =
          "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark/places/22-yellow";
        "icons/Gruvbox-Plus-Dark/places/24".source =
          "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark/places/24-yellow";
        "icons/Gruvbox-Plus-Dark/places/32".source =
          "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark/places/32-yellow";
        "icons/Gruvbox-Plus-Dark/places/48".source =
          "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark/places/48-yellow";
        "icons/Gruvbox-Plus-Dark/places/64".source =
          "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark/places/64-yellow";
        "icons/Gruvbox-Plus-Dark/places/96".source =
          "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark/places/96-yellow";
        "icons/Gruvbox-Plus-Dark/places/128".source =
          "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark/places/128-yellow";
        "icons/Gruvbox-Plus-Dark/places/256".source =
          "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark/places/256-yellow";

        # Keep your custom flat-black CSS configs exactly how they were!
        "gtk-4.0/assets" = {
          force = true;
          source = "${pkgs.gruvbox-gtk-theme}/share/themes/${gruvbox-theme-name}/gtk-4.0/assets";
        };
        "gtk-4.0/gtk.css" = {
          force = true;
          source = "${pkgs.gruvbox-gtk-theme}/share/themes/${gruvbox-theme-name}/gtk-4.0/gtk.css";
        };
        "gtk-4.0/gtk-dark.css".text = ''
          @import url("${pkgs.gruvbox-gtk-theme}/share/themes/${gruvbox-theme-name}/gtk-4.0/gtk-dark.css");
          window, .background, messagebox, dialog { background-color: #000000; }
          headerbar, .titlebar { background-color: #050505; box-shadow: none; }
        '';
        "gtk-3.0/gtk.css".text = ''
          @import url("${pkgs.gruvbox-gtk-theme}/share/themes/${gruvbox-theme-name}/gtk-3.0/gtk.css");
          window, .background, messagebox, dialog { background-color: #000000; }
          .thunar, .thunar window, .thunar .background, ThunarWindow { background-color: #000000; background-image: none; }
          .thunar .sidebar, .thunar .sidebar treeview, .thunar .standard-view, .thunar .standard-view .view, .thunar scrolledwindow { background-color: #000000; background-image: none; }
          headerbar, .titlebar, .thunar .toolbar, .thunar toolbar { background-color: #050505; background-image: none; box-shadow: none; }
        '';
      };
    })
  ];
}
{ pkgs, ... }:

let
  gruvbox-theme-name = "Gruvbox-Dark";
in
{
  # 1. Keep the packages global and clean
  environment.systemPackages = with pkgs; [
    gruvbox-plus-icons
    bibata-cursors
    gruvbox-gtk-theme
  ];

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  home-manager.sharedModules = [
    (_: {
      home.pointerCursor = {
        enable = true;
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };

      gtk = {
        enable = true;
        gtk2.force = true;
        theme = {
          name = "${gruvbox-theme-name}";
          package = pkgs.gruvbox-gtk-theme;
        };
        # 2. Reset the icon theme back to the standard dark layout
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

      home.sessionVariables = {
        ADW_COLOR_SCHEME = "prefer-dark";
      };
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };

      # 3. Intercept the standard folder assets inside your user profile
      xdg.dataFile = {
        "icons/Gruvbox-Plus-Dark/places/16".source =
          "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark/places/16-yellow";
        "icons/Gruvbox-Plus-Dark/places/22".source =
          "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark/places/22-yellow";
        "icons/Gruvbox-Plus-Dark/places/24".source =
          "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark/places/24-yellow";
        "icons/Gruvbox-Plus-Dark/places/32".source =
          "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark/places/32-yellow";
        "icons/Gruvbox-Plus-Dark/places/48".source =
          "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark/places/48-yellow";
        "icons/Gruvbox-Plus-Dark/places/64".source =
          "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark/places/64-yellow";
        "icons/Gruvbox-Plus-Dark/places/96".source =
          "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark/places/96-yellow";
        "icons/Gruvbox-Plus-Dark/places/128".source =
          "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark/places/128-yellow";
        "icons/Gruvbox-Plus-Dark/places/256".source =
          "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark/places/256-yellow";

        # Keep your custom flat-black CSS configs exactly how they were!
        "gtk-4.0/assets" = {
          force = true;
          source = "${pkgs.gruvbox-gtk-theme}/share/themes/${gruvbox-theme-name}/gtk-4.0/assets";
        };
        "gtk-4.0/gtk.css" = {
          force = true;
          source = "${pkgs.gruvbox-gtk-theme}/share/themes/${gruvbox-theme-name}/gtk-4.0/gtk.css";
        };
        "gtk-4.0/gtk-dark.css".text = ''
          @import url("${pkgs.gruvbox-gtk-theme}/share/themes/${gruvbox-theme-name}/gtk-4.0/gtk-dark.css");
          window, .background, messagebox, dialog { background-color: #000000; }
          headerbar, .titlebar { background-color: #050505; box-shadow: none; }
        '';
        "gtk-3.0/gtk.css".text = ''
          @import url("${pkgs.gruvbox-gtk-theme}/share/themes/${gruvbox-theme-name}/gtk-3.0/gtk.css");
          window, .background, messagebox, dialog { background-color: #000000; }
          .thunar, .thunar window, .thunar .background, ThunarWindow { background-color: #000000; background-image: none; }
          .thunar .sidebar, .thunar .sidebar treeview, .thunar .standard-view, .thunar .standard-view .view, .thunar scrolledwindow { background-color: #000000; background-image: none; }
          headerbar, .titlebar, .thunar .toolbar, .thunar toolbar { background-color: #050505; background-image: none; box-shadow: none; }
        '';
      };
    })
  ];
}
