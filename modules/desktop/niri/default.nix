{
  host,
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../../themes/Catppuccin
    ./dms                  # Points exactly to your uppercase DMS folder
    ./rofi
  ];

  # Niri binary cache settings to prevent local compilation
  nix.settings = {
    substituters = [ "https://niri.cachix.org" ];
    trusted-public-keys = [ "niri.cachix.org-1:Wv0Om60u5f0m73/8w7+U267eNInK9Yubun7ZasfSgY8=" ];
  };

  # Set Niri as the default session for your Display Manager
  services.displayManager.defaultSession = "niri";

  # System level portals configuration
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome # Essential backend for Niri window/screen tracking
      xdg-desktop-portal-gtk
    ];
    xdgOpenUsePortal = true;
  };

  # Core Flake deployment hooks
  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;
  };

  home-manager.sharedModules = [
    (_: {
      # Link your local settings.nix configuration into home-manager's niri instance
      imports = [ ./settings.nix ];

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
        ];
        xdgOpenUsePortal = true;
        configPackages = [ config.programs.niri.package ];
        config.niri = {
          default = [
            "gnome"
            "gtk"
          ];
          "org.freedesktop.impl.portal.OpenURI" = "gtk";
          "org.freedesktop.impl.portal.FileChooser" = "gtk";
          "org.freedesktop.impl.portal.Print" = "gtk";
        };
      };

      # Set wallpaper service
      services.awww.enable = true;

      # Filtered and preserved functional user packages
      home.packages = with pkgs; [
        cliphist        # Clipboard history manager daemon
        swappy          # Snapshot editor and annotator
        libnotify       # Notification send tool (notify-send)
        wtype           # Wayland keyboard input simulator
        wl-clipboard    # Clipboard access commands (wl-copy, wl-paste)
        pavucontrol     # PulseAudio Volume Control GUI
        brightnessctl   # Lightweight screen brightness control utility
        playerctl       # Command-line utility for controlling media players
        pamixer         # PulseAudio command-line mixer
        grim            # Pure Wayland screen grabber
        slurp           # Region selector for screenshots
      ];
    })
  ];
}