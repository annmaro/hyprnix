{ config, pkgs, ... }:

{
  home-manager.sharedModules = [
    (_: {
      home.packages = [ pkgs.rmpc ];

      xdg.configFile."rmpc/config.ron".text = ''
        #![enable(implicit_some)]
        (
          address: "127.0.0.1:6600",
          theme: Some("default"),
        )
      '';
    })
  ];
}
