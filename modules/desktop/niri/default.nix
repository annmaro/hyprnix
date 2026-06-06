{
  self,
  host,
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;
  inherit (import "${self}/hosts/${host}/variables.nix")
    browser
    terminal
    tuiFileManager
    kbdLayout
    kbdVariant
    ;

  # Import script modules explicitly to map them into your hotkeys
  clipmanager = pkgs.callPackage ./scripts/clipmanager.nix { };
  fileManagerScript = pkgs.callPackage ./scripts/file-manager.nix { inherit terminal; };
  gamemode = pkgs.callPackage ./scripts/gamemode.nix { };
  wallpaper = pkgs.callPackage ./scripts/wallpaper.nix { };
  keybindsRofi = pkgs.callPackage ./scripts/keybinds-rofi.nix { };
in
{
  imports = [
    ./dms
    ./rofi
    ./stylix
    ./swaylock
  ];

  # Standard core CLI/desktop utility tools
  environment.systemPackages = with pkgs; [
    cliphist # Clipboard history manager daemon
    swappy # Snapshot editor and annotator
    libnotify # Notification send tool (notify-send)
    wtype # Wayland keyboard input simulator
    wl-clipboard # Clipboard access commands (wl-copy, wl-paste)
    pavucontrol # PulseAudio Volume Control GUI
    brightnessctl # Lightweight screen brightness control utility
    playerctl # Command-line utility for controlling media players
    pamixer # PulseAudio command-line mixer
    grim # Pure Wayland screen grabber
    slurp # Region selector for screenshots
    thunar-volman # Necessary if you use Thunar for drive popups
    gnome-disk-utility # Gives you a clean GUI to verify physical blocks
    wlsunset # Day/night gamma adjustments for Wayland
    waypaper # Wayland background setter, used here to manage wallpaper cycles with awww
  ];

  # Niri binary cache settings to prevent local compilation
  nix.settings = {
    substituters = [ "https://niri.cachix.org" ];
    trusted-public-keys = [ "niri.cachix.org-1:Wv0Om606Z56fUlrrlM7A31YAL9G3g9/S9SpvSNGOfYg=" ];
  };

  # Set Niri as the default session for your Display Manager
  services.displayManager.defaultSession = "niri";

  # Core Flake deployment hooks (System-wide package)
  programs.niri = {
    enable = true;
  };

  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        imports = [
          # we disabled inputs.niri.homeModules.niri to prevent conflicts on hm.kdl
        ];

        # Set wallpaper
        services.awww.enable = true;

        # Install our wrapped Niri package using wrapper-modules
        home.packages = [
          (inputs.wrapper-modules.wrappers.niri.wrap {
            inherit pkgs;
            settings = import ./settings.nix {
              inherit
                config
                pkgs
                getExe
                kbdLayout
                kbdVariant
                wallpaper
                keybindsRofi
                ;
            };
          })
        ];

        # System Niri is launched by the Display Manager and reads ~/.config/niri/config.kdl
        # which imports hm.kdl. Since niri-flake homeModule is disabled, we write the
        # custom KDL directly to hm.kdl without any collisions!
        xdg.configFile."niri/hm.kdl" = lib.mkForce {
          text = inputs.wrapper-modules.lib.toKdl (
            import ./settings.nix {
              inherit
                config
                pkgs
                getExe
                kbdLayout
                kbdVariant
                wallpaper
                keybindsRofi
                ;
            }
          );
        };

        xdg.portal = {
          enable = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-gnome
            xdg-desktop-portal-gtk
          ];
          xdgOpenUsePortal = true;
          configPackages = [ pkgs.niri ];
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
      }
    )
  ];
}
