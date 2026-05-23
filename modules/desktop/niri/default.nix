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
    ./rofi
    ./themes
  ];

  # Standard core CLI/desktop utility tools
  environment.systemPackages = with pkgs; [
    cliphist              # Clipboard history manager daemon
    swappy                # Snapshot editor and annotator
    libnotify             # Notification send tool (notify-send)
    wtype                 # Wayland keyboard input simulator
    wl-clipboard          # Clipboard access commands (wl-copy, wl-paste)
    pavucontrol           # PulseAudio Volume Control GUI
    brightnessctl         # Lightweight screen brightness control utility
    playerctl             # Command-line utility for controlling media players
    pamixer               # PulseAudio command-line mixer
    grim                  # Pure Wayland screen grabber
    slurp                 # Region selector for screenshots
    thunar-volman    # Necessary if you use Thunar for drive popups
    gnome-disk-utility    # Gives you a clean GUI to verify physical blocks
    wlsunset              # Day/night gamma adjustments for Wayland

    (pkgs.writeShellScriptBin "wlsunset-toggle" ''
      # If forced night mode is running, switch to auto
      if pgrep -f "wlsunset -T 3001" > /dev/null; then
        pkill wlsunset
        wlsunset -l 23.3 -L 85.3 -T 6500 -t 3000 &
        notify-send -i weather-clear "Display" "Auto color temperature enabled"
      else
        # Else force night mode
        pkill wlsunset
        wlsunset -T 3001 -t 3000 &
        notify-send -i weather-clear-night "Display" "Night mode forced (3000K)"
      fi
    '')
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