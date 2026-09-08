{ config, pkgs, ... }:

{
  home-manager.sharedModules = [
    (_: {
      services.easyeffects = {
        enable = true;
      };
      
      # We also ensure the package is available so you can launch the GUI
      home.packages = [ pkgs.easyeffects ];
    })
  ];
}
