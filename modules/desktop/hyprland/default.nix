{
  host,
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optional;
  inherit (import ../../../hosts/${host}/variables.nix) bar;
in
{
  imports = [
    ../../themes/Catppuccin
    ./variables.nix
    ./programs/${bar}
    ./programs/wlogout
    ./programs/rofi
    ./programs/hypridle
    ./programs/hyprlock
  ]
  ++ optional (bar != "wayle") ./programs/swaync;

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  systemd.user.services.hyprpolkitagent = {
    description = "Hyprpolkitagent - Polkit authentication agent";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  services.displayManager.defaultSession = "hyprland";

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    xdgOpenUsePortal = true;
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  home-manager.sharedModules = [
    (_: {
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];
        xdgOpenUsePortal = true;
        configPackages = [ config.programs.hyprland.package ];
        config.hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.OpenURI" = "gtk";
          "org.freedesktop.impl.portal.FileChooser" = "gtk";
          "org.freedesktop.impl.portal.Print" = "gtk";
        };
      };

      # Set wallpaper
      services.awww.enable = true;

      # User packages for desktop functionality and workflow scripts
      home.packages = with pkgs; [
        hyprpicker      # Color picker utility
        cliphist        # Clipboard history manager daemon
        grimblast       # Screen grabber helper script
        swappy          # Snapshot editor and annotator
        libnotify       # Notification send tool (notify-send)
        wtype           # Wayland keyboard input simulator
        wl-clipboard    # Clipboard access commands (wl-copy, wl-paste)
        xdotool         # X11 automation simulation compatibility
        hyprsunset      # Wayland blue light filter manager
        pavucontrol     # PulseAudio Volume Control GUI
        brightnessctl   # Lightweight screen brightness control utility
        playerctl       # Command-line utility for controlling media players
        pamixer         # PulseAudio command-line mixer (handles audio volume, toggles mute)
      ];

      # Hyprland config
      xdg.configFile = {
        "hypr/hyprland.lua".source = ./lua/hyprland.lua;
        "hypr/monitors.lua".source = ./lua/monitors.lua;
        "hypr/settings.lua".source = ./lua/settings.lua;
        "hypr/animations.lua".source = ./lua/animations.lua;
        "hypr/binds.lua".source = ./lua/binds.lua;
        "hypr/rules.lua".source = ./lua/rules.lua;

        "hypr/icons" = {
          source = ./icons;
          recursive = true;
        };
      };
    })
  ];
}
