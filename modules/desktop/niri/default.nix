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
    ./dms
    ./awww                  
    ./rofi
    ./themes
  ];

  # Standard core CLI/desktop utility tools
  environment.systemPackages = with pkgs; [
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
    xfce.thunar-volman  # Necessary if you use Thunar for drive popups
    gnome-disk-utility  # Gives you a clean GUI to verify physical blocks
    hyprsunset       # Automatic color temperature adjustment daemon
  ];

  # Niri binary cache settings to prevent local compilation
  nix.settings = {
    substituters = [ "https://niri.cachix.org" ];
    trusted-public-keys = [ "niri.cachix.org-1:Wv0Om60u5f0m73/8w7+U267eNInK9Yubun7ZasfSgY8=" ];
  };

  # Set Niri as the default session for your Display Manager
  services.displayManager.defaultSession = "niri";

  # Core Flake deployment hooks
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  home-manager.sharedModules = [
    (_: {
      imports = [
        inputs.niri.homeModules.niri
      ];

      # Automatically map the clean options from settings.nix into Home Manager's Niri module
      programs.niri.settings = import ./settings.nix { inherit pkgs config; };

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
    })
  ];
}