# ./awww/default.nix
{ pkgs, ... }: {

  home-manager.sharedModules = [
    (_: {
      # 1. Ensure the required tools are installed in your user profile
      home.packages = with pkgs; [
        #awww       # The core wallpaper engine backend
        #waypaper   # The graphical frontend configuration manager
      ];

      # 2. Configure awww to run as a supervised background service
      services.awww.enable = false;

    /* # 3. Create a managed post-start service hook to handle the waypaper restoration delay
      systemd.user.services.waypaper-restore = {
        Unit = {
          Description = "Restore waypaper wallpaper profile on graphical boot";
          PartOf = [ "graphical-session.target" "awww.service" ];
          After = [ "awww.service" ]; # Wait until the awww daemon backend is actively running
        };

        Service = {
          Type = "oneshot";
          # Sleep for 0.5 seconds to let the backend settle, then call waypaper to restore
          ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/sleep 0.5 && ${pkgs.waypaper}/bin/waypaper --restore'";
          RemainAfterExit = true;
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };*/
    })
  ];
}