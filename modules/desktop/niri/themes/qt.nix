{ pkgs, ... }:

let
  variant = "mocha";
  accent = "mauve";
  catppuccin-kvantum-pkg = pkgs.catppuccin-kvantum.override { inherit variant accent; };
  catppuccin-theme-name = "catppuccin-${variant}-${accent}";
in
{
  # Install the core Qt style sheet engines globally
  environment.systemPackages = with pkgs; [
    qt6Packages.qt6ct
    libsForQt5.qt5ct
    catppuccin-kvantum-pkg
  ];

  # Universal Wayland engine properties
  environment.variables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  # Link the configurations into your user session profile
  home-manager.sharedModules = [
    (_: {
      qt = {
        enable = true;
        platformTheme.name = "qt5ct"; # Routes configuration mappings natively
        style.name = "kvantum";
      };

      # Declaratively construct your configurations to avoid manual mouse UI settings
      xdg.configFile = {
        "qt5ct/qt5ct.conf".text = ''
          [Appearance]
          style=kvantum
          icon_theme=Papirus-Dark
        '';
        "qt6ct/qt6ct.conf".text = ''
          [Appearance]
          style=kvantum
          icon_theme=Papirus-Dark
        '';
        "Kvantum/${catppuccin-theme-name}".source = "${catppuccin-kvantum-pkg}/share/Kvantum/${catppuccin-theme-name}";
        "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
          General.theme = catppuccin-theme-name;
        };
      };
    })
  ];
}