{ self, pkgs, ... }:

let
  # Using the standardized Gruvbox theme definition
  amoledTheme = import (self + "/modules/desktop/niri/dms/dms_theme.nix") { inherit pkgs; };
  bg = (builtins.elemAt amoledTheme.variants.flavors 0).dark.background;
  accent = (builtins.elemAt amoledTheme.variants.accents 11).black.primary;
in
{
  # Install the core Qt style sheet engines globally
  environment.systemPackages = with pkgs; [
    qt6Packages.qt6ct
    libsForQt5.qt5ct
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
        platformTheme.name = "qt6ct"; # Routes configuration mappings natively
        style.name = "breeze"; # Use a standard responsive engine instead of kvantum
      };

      # Generate the qt6ct color scheme file dynamically
      xdg.configFile."qt6ct/colors/Amoled.conf".text = ''
        [Colors]
        Window=${bg}
        WindowText=#ffffff
        Base=${bg}
        AlternateBase=#111111
        Button=#1c1c1c
        Highlight=${accent}
        HighlightedText=#000000
      '';
    })
  ];
}
