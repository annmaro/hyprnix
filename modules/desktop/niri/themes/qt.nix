{ pkgs, ... }:

let
  # Using the standardized Gruvbox theme definition
  gruvbox-theme-name = "Gruvbox-Dark";
in
{
  # Install the core Qt style sheet engines globally
  environment.systemPackages = with pkgs; [
    qt6Packages.qt6ct
    libsForQt5.qt5ct
    gruvbox-kvantum
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
          icon_theme=Gruvbox-Plus-Dark
        '';
        "qt6ct/qt6ct.conf".text = ''
          [Appearance]
          style=kvantum
          icon_theme=Gruvbox-Plus-Dark
        '';
        "Kvantum/${gruvbox-theme-name}".source = "${pkgs.gruvbox-kvantum}/share/Kvantum/${gruvbox-theme-name}";
        
        # Enforce high-contrast pure black window bases inside Kvantum
        "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
          General.theme = gruvbox-theme-name;
          OpaqueEffects.reduce_opacity = false;
          UserStyles.blend_colors = false;
        };
      };
    })
  ];
}