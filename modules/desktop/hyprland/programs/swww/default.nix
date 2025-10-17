{ pkgs, lib, ... }:


 let
    wpPath = "/tmp/current_wallpaper";
 in
 {
  home-manager.sharedModules = [
(_: {

  # Packages needed for wallpapers
  home.packages = with pkgs; [
    swww
    waypaper
  ];

  # Waypaper configuration (defaults; Waypaper will create it if absent)
  xdg.configFile."waypaper/config.ini".text = lib.generators.toINI { } {
    Settings = {
      language = "en";
      folder = "~/Pictures/Wallpapers";
      post_command = "ln -sf \"$wallpaper\" ${wpPath}";
      zen_mode = "false";
      backend = "swww";
      show_path_in_tooltip = "true";
      fill = "fill";
      sort = "name";
      color = "ffffff";
      subfolders = "false";
      all_subfolders = "false";
      show_hidden = "false";
      show_gifs_only = "false";
      umber_of_columns = "3";
      swww_transition_type = "fade";
      swww_transition_step = "90";
      swww_transition_angle = "0";
      swww_transition_fps = "144";
    };
  };

  systemd.user.services = {
    # Animated Wayland wallpaper daemon
    swww-daemon = {
      Unit = {
        Description = "swww daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.swww}/bin/swww-daemon";
        Restart = "on-failure";
        RestartSec = 1;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # Restore last wallpaper via Waypaper at session start (uses swww backend)
    waypaper-restore = {
      Unit = {
        Description = "Restore wallpaper with Waypaper";
        PartOf = [ "graphical-session.target" ];
        After = [
          "swww-daemon.service"
          "graphical-session-pre.target"
        ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.waypaper}/bin/waypaper --restore";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
})
];
}