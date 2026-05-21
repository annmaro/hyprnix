{
  host,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;
  inherit (import ../../../hosts/${host}/variables.nix)
    bar
    browser
    terminal
    tuiFileManager
    kbdLayout
    kbdVariant
    ;

  # Import script modules
  # autowaybar = pkgs.callPackage ./scripts/autowaybar.nix { };
  autoclicker = pkgs.callPackage ./scripts/autoclicker.nix { };
  batterynotify = pkgs.callPackage ./scripts/batterynotify.nix { };
  clipmanager = pkgs.callPackage ./scripts/clipmanager.nix { };
  fileManagerScript = pkgs.callPackage ./scripts/file-manager.nix { inherit terminal; };
  gamemode = pkgs.callPackage ./scripts/gamemode.nix { };
  keyboardswitch = pkgs.callPackage ./scripts/keyboardswitch.nix { };
  keybinds = pkgs.callPackage ./scripts/keybinds.nix { };
  # keybinds-rofi = pkgs.callPackage ./scripts/keybinds-yad.nix { };
  # mediactrl = pkgs.callPackage ./scripts/mediactrl.nix { };
  launcher = pkgs.callPackage ../../scripts/launcher.nix { inherit lib pkgs terminal; };
  rofimusic = pkgs.callPackage ./scripts/rofimusic.nix { };
  screen-record = pkgs.callPackage ./scripts/screen-record.nix { };
  screenshot = pkgs.callPackage ./scripts/screenshot.nix { };
  wallpaper = pkgs.callPackage ./scripts/wallpaper.nix { inherit defaultWallpaper; };
in
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        xdg.configFile."hypr/variables.lua" = {
          text = ''
            -- Scripts
            autoclicker = "${getExe autoclicker}"
            batterynotify = "${getExe batterynotify}"
            clipmanager = "${getExe clipmanager}"
            fileManagerScript = "${getExe fileManagerScript}"
            gamemode = "${getExe gamemode}"
            keyboardswitch = "${getExe keyboardswitch}"
            keybinds = "${getExe keybinds}"
            rofimusic = "${getExe rofimusic}"
            screen_record = "${getExe screen-record}"
            screenshot = "${getExe screenshot}"
            wallpaper = "${getExe wallpaper}"

            mainMod = "SUPER"
            launcher = "${getExe launcher}"
            bar = "${if bar == "wayle" then "wayle shell" else bar}"
            term = "${terminal}"
            editor = "code"
            browser = "${browser}"
            tuiFileManager = "${tuiFileManager}"
            kbdLayout = "${kbdLayout}"
            kbdVariant = "${kbdVariant}"
          '';
        };
      }
    )
  ];
}
