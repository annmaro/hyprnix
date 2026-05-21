{
  host,
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (import ../../../hosts/${host}/variables.nix);
in
{
  imports = [
    ../../themes/Catppuccin
    ./variables.nix
    ./programs/waybar
    ./programs/wlogout
    ./programs/rofi
    ./programs/hypridle
    ./programs/hyprlock
    ./programs/swaync
  ];

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
