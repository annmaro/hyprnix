{
  host,
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
    inherit (import ../../../hosts/${host}/variables.nix) bar;
in
{
  imports = [
    ../../themes/Catppuccin
    ./variables.nix
    ./programs/${bar}
    ./programs/rofi
  ];

  # Niri binary cache settings to prevent local compilation compilation
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
        grim            # Pure Wayland screen grabber (replaces grimblast)
        slurp           # Region selector for screenshots
      ];

      # Declarative Niri configuration structure (Replaces your old Lua files mapping)
      programs.niri.settings = {
        prefer-no-csd = true;

        # Layout Rules (Infinite Horizontal Ribbon)
        layout = {
          gaps = 8;
          center-focused-column = "never";
          border = {
            enable = true;
            width = 2;
            active.color = "#7aa2f7";     # Change to your preferred layout colors
            inactive.color = "#414868";
          };
        };

        # Input & Keybindings Mapping
        binds = {
          # Terminal & App Launcher
          "Mod+Return".action.spawn = [ "ghostty" ]; 
          "Mod+D".action.spawn = [ "rofi" "-show" "drun" ]; # Multi-arg syntax built cleanly
          "Mod+Q".action.close-window = [ ];

          # Infinite horizontal column management
          "Mod+Left".action.focus-column-left = [ ];
          "Mod+Right".action.focus-column-right = [ ];
          "Mod+Ctrl+Left".action.move-column-left = [ ];
          "Mod+Ctrl+Right".action.move-column-right = [ ];

          # Vertical Dynamic Workspace navigation (Relative Stack)
          "Mod+Up".action.focus-workspace-up = [ ];
          "Mod+Down".action.focus-workspace-down = [ ];
          "Mod+Ctrl+Up".action.move-column-to-workspace-up = [ ];
          "Mod+Ctrl+Down".action.move-column-to-workspace-down = [ ];

          # Mouse Wheel navigation scroll support 
          "Mod+WheelScrollDown".action.focus-workspace-down = [ ];
          "Mod+WheelScrollUp".action.focus-workspace-up = [ ];

          # Window sizing presets
          "Mod+R".action.switch-preset-column-width = [ ];
          "Mod+F".action.maximize-column = [ ];
          "Mod+Shift+F".action.fullscreen-window = [ ];

          # Hardware controls bindings matching your utilities
          "XF86AudioRaiseVolume".action.spawn = [ "pamixer" "-i" "5" ];
          "XF86AudioLowerVolume".action.spawn = [ "pamixer" "-dec" "5" ];
          "XF86AudioMute".action.spawn = [ "pamixer" "-t" ];
          "XF86MonBrightnessUp".action.spawn = [ "brightnessctl" "set" "10%+" ];
          "XF86MonBrightnessDown".action.spawn = [ "brightnessctl" "set" "10%-" ];

          # Screenshot integration (Replacing grimblast with an explicit grim execution script)
          "Mod+Shift+S".action.spawn = [ "sh" "-c" "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -" ];
        };

        # Window rules
        window-rules = [
          {
            matches = [ { app-id = "pavucontrol"; } ];
            open-floating = true;
          }
        ];
      };
    })
  ];
}