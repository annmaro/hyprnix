{ pkgs, ... }:

{
  home-manager.sharedModules = [
    ({ ... }: {
      programs.eww = {
        enable = true;
        package = pkgs.eww;
      };

      # Safely link external files directly into XDG home configuration
      xdg.configFile."eww/eww.yuck".source = ./eww.yuck;
      xdg.configFile."eww/eww.scss".source = ./eww.scss;
    })
  ];
}