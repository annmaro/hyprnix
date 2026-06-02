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

  # Core Flake deployment hooks
  programs.niri = {
    enable = true;
  };

  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        imports = [
          inputs.niri.homeModules.niri
        ];

        # Set wallpaper
        services.awww.enable = true;

        # This empty set satisfies the module validator to prevent the null-error,
        # ensuring your native KDL string below generates seamlessly.
        programs.niri.package = pkgs.niri-unstable;
        programs.niri.settings = { };

        # =====================================================================
        # 🎛️ NIRI NATIVE KDL CONFIGURATION (All settings managed here)
        # =====================================================================
        programs.niri.config = ''
          // 🌍 ENVIRONMENT VARIABLES & SYSTEM SETTINGS
          prefer-no-csd
          hotkey-overlay {
              skip-at-startup
          }

          environment {
              XDG_CURRENT_DESKTOP "niri"
              XDG_SESSION_DESKTOP "niri"
              XDG_SESSION_TYPE "wayland"
              GDK_BACKEND "wayland,x11,*"
              NIXOS_OZONE_WL "1"
              ELECTRON_OZONE_PLATFORM_HINT "wayland"
              MOZ_ENABLE_WAYLAND "1"
              OZONE_PLATFORM "wayland"
              EGL_PLATFORM "wayland"
              CLUTTER_BACKEND "wayland"
              SDL_VIDEODRIVER "wayland"
              WLR_RENDERER_ALLOW_SOFTWARE "1"
              NIXPKGS_ALLOW_UNFREE "1"
              DMS_DISABLE_MATUGEN "0"
          }

          // 🚀 SPAWN ON STARTUP / AUTOSTART DAEMONS
          spawn-sh-at-startup "sleep 1 && wlsunset -T 3800 -t 3799"
          spawn-at-startup "sh" "-c" "sleep 2 && thunar --daemon"

          // 🖼️ Initialize your awww + waypaper background cycle right away
          spawn-at-startup "${getExe wallpaper}"

          // ADD THESE LINES TO ACTUALLY LAUNCH DANK MATERIAL SHELL
          spawn-at-startup "dms"



          // ⌨️ HARDWARE INPUT & TOUCHPAD MANAGEMENT
          input {
              keyboard {
                  xkb {
                   // Pulls layouts seamlessly from your host variables
                    layout "${kbdLayout}"
                    variant "${kbdVariant}"
                  }
                  repeat-delay 275
                  repeat-rate 35
                  track-layout "global"
              }
               touchpad {
                   click-method "clickfinger"
               }
              mouse {
                  accel-profile "flat"
                  accel-speed 0.0
              }
              warp-mouse-to-focus
              focus-follows-mouse
          }

          // 🖥️ DISPLAY OUTPUTS & PERSISTENT LAYOUT
          output "desc:BOE 0x0690" {
              mode "1920x1080@60.014"
              scale 1.0
              position x=0 y=0
          }

           // Define your fixed workspaces
           workspace "1"
           workspace "2"

            // 🌫️ GLOBAL COMPOSITOR CONFIGURATION (Top Level)
            // (This controls how Niri places windows relative to the bar)
           blur {
               passes 3       
               offset 3.0     
               noise 0.02     
               saturation 1.1 
           }

          // 📐 LAYOUT STYLE & WINDOW GAPS
          layout {
              gaps 9
              center-focused-column "never"
              background-color "transparent"
               border {
                  width 1
          // Targets the dynamic system accent color generated by Stylix 
          active-color "#${config.lib.stylix.colors.base0A}" 
          // Targets the default dim/outline color from your Stylix palette
          inactive-color "#${config.lib.stylix.colors.base03}"
              }
              preset-column-widths {
                  proportion 0.33333
                  proportion 0.5
                  proportion 0.66667
              }
          }



          // 🎛️ LAYER RULES (Overview background)

           layer-rule {
               match namespace="^awww$"
               place-within-backdrop true
              }

            layer-rule {
               match namespace="^overview$"   
               place-within-backdrop true
              }  

          overview {
               workspace-shadow { 
                off
               }
           }           

           

           layer-rule {
               match namespace="^rofi$"
               geometry-corner-radius 12

               background-effect {
                   blur true
                   xray false
                   noise 0.03
                   saturation 1.25
               } 
           }

          // Force normal, realistic blur for DankMaterialShell popups and panels
          layer-rule {
               match namespace=r#"^dms:.*"#
               background-effect {
                   
                   xray false
               }
           } 


          // 🖼️ WINDOW RULES & TRANSPARENCY
          window-rule {
              geometry-corner-radius 12
              clip-to-geometry true
          }

          window-rule {
              match app-id="^(firefox|zen-beta|floorp|brave-|vlc|easyeffects|gapless)$"
              open-maximized-to-edges true
              draw-border-with-background false
              opacity 1.0
           }

          window-rule {
              match app-id="^(kitty|neovim|com.mitchellh.ghostty|Alacritty|org.wezfurlong.wezterm)$"
              opacity 0.70
              draw-border-with-background false
              background-effect {
                   blur true
                   xray false
              }
          }

          window-rule {
              match app-id="^(gnome-disks|org.gnome.Nautilus|thunar|pcmanfm|file-roller|steamwebhelper|spotify|com.github.th_ch.youtube_music)$"
              opacity 0.70
              draw-border-with-background false
              background-effect {
                   blur true
                   xray false
              }
          }

          window-rule {
              match app-id="^(Emacs|obsidian|proton.vpn.app.gtk|heroic|lutris|discord|webcord|vesktop|neovim|nvim-wrapper|antigravity|VSCodium|code)$"
              opacity 0.80
              draw-border-with-background false
              background-effect {
                   blur true
                   xray false
             }      
          }

          window-rule {
              match app-id="^(pavucontrol|blueman-manager|nm-applet|nm-connection-editor|nwg-look|qt5ct|qt6ct|yad|app.drey.Warp|net.davidotek.pupgui2|Signal|io.gitlab.theevilskeleton.Upscaler|eog)$"
              open-floating true
          }

          window-rule {
              match title="^Picture-in-Picture$"
              open-floating true
          }



          // 🕹️ KEYBINDINGS & WORKFLOW CONTROLS
          binds {
              "Mod+Return" { spawn "ghostty"; }
              "Mod+T" { spawn "kitty"; }
              "Mod+C" { spawn "editor"; }
              "Mod+F" { spawn "firefox"; }
              "Mod+A" { spawn "antigravity"; }
              "Mod+Space" { spawn "rofi" "-show" "drun"; }
              "Mod+V" { spawn "rofi" "-show" "clipboard"; }
              "Mod+Z" { spawn "rofi" "-show" "emoji"; }
              "Mod+G" { spawn "launcher" "games"; }
              "Mod+Alt+G" { spawn "gamemode"; }
              "Mod+Q" { close-window; }
              "Mod+Delete" { quit; }
              "Mod+Alt+L" { spawn "dms" "session" "lock"; }
              "Mod+N" { spawn "dms" "ipc" "call" "notifications" "toggle"; }
              "Mod+D" { spawn "eww" "open" "--toggle" "dashboard"; }
              "Mod+Shift+E" { spawn "dms" "ipc" "call" "session" "toggle"; }
              "Mod+Shift+C" { spawn "code"; }
              "Mod+Shift+R" { spawn "sh" "-c" "thunar -q && thunar --daemon"; }
              "Mod+Backspace" { spawn "sh" "-c" "pkill -x wlogout || wlogout -b 4"; }
              "Mod+Shift+S" { spawn "spotify"; }
              "Mod+Shift+Y" { spawn "youtube-music"; }
              "Ctrl+Alt+Delete" { spawn "ghostty" "-e" "btop"; }
              "Mod+Ctrl+C" { spawn "hyprpicker" "--autocopy" "--format=hex"; }
              "Mod+F9" { spawn "sh" "-c" "wlsunset -T 3800 -t 3799"; }
              "Mod+F10" { spawn-sh "pkill -9 wlsunset || killall -9 wlsunset"; }
              
              "Mod+Left" { focus-column-left; }
              "Mod+Right" { focus-column-right; }
              "Mod+H" { focus-column-left; }
              "Mod+L" { focus-column-right; }
              "Mod+S" { spawn "sh" "-c" "niri msg action toggle-overview && killall -SIGUSR1 waybar && dms ipc call overview toggle"; }
              "Mod+Ctrl+Left" { move-column-left; }
              "Mod+Ctrl+Right" { move-column-right; }
              
              "Mod+K" { focus-window-up; }
              "Mod+J" { focus-window-down; }
              "Mod+Ctrl+K" { move-column-to-workspace-up; }
              "Mod+Ctrl+J" { move-column-to-workspace-down; }
              "Mod+WheelScrollDown" { focus-workspace-down; }
              "Mod+WheelScrollUp" { focus-workspace-up; }

              "Mod+R" { switch-preset-column-width; }
              "Mod+M" { maximize-column; }
              "Alt+Return" { fullscreen-window; }
              "Mod+W" { toggle-window-floating; }
              "Mod+1" { focus-workspace 1; }
              "Mod+2" { focus-workspace 2; }
              "Mod+3" { focus-workspace 3; }
              "Mod+Shift+1" { move-column-to-workspace 1; }
              "Mod+Shift+2" { move-column-to-workspace 2; }
              "Mod+Shift+3" { move-column-to-workspace 3; }
              "Mod+Shift+4" { move-column-to-workspace 4; }
              "Mod+Shift+5" { move-column-to-workspace 5; }

              "XF86AudioRaiseVolume" { spawn "pamixer" "-i" "2"; }
              "XF86AudioLowerVolume" { spawn "pamixer" "-d" "2"; }
              "XF86AudioMute" { spawn "pamixer" "-t"; }
              "XF86AudioMicMute" { spawn "pamixer" "--default-source" "-t"; }
              "XF86MonBrightnessUp" { spawn "brightnessctl" "set" "+2%"; }
              "XF86MonBrightnessDown" { spawn "brightnessctl" "set" "2%-"; }
              "XF86AudioPlay" { spawn "playerctl" "play-pause"; }
              "XF86AudioPause" { spawn "playerctl" "play-pause"; }
              "XF86AudioNext" { spawn "playerctl" "next"; }
              "XF86AudioPrev" { spawn "playerctl" "previous"; }
              "XF86Sleep" { spawn "systemctl" "suspend"; }
              "Mod+Up" { focus-window-or-workspace-up; }
              "Mod+Down" { focus-window-or-workspace-down; }
              "Mod+Ctrl+Up" { move-workspace-up; }
              "Mod+Ctrl+Down" { move-workspace-down; }
              "Mod+P" { spawn "sh" "-c" "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -"; }
              "Mod+Ctrl+P" { spawn "sh" "-c" "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -"; }
          }
        '';

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
      }
    )
  ];
}
