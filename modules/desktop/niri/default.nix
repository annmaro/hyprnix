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
  ];

  # Niri binary cache settings to prevent local compilation
  nix.settings = {
    substituters = [ "https://niri-nix.cachix.org" ];
    trusted-public-keys = [ "niri-nix.cachix.org-1:SvFtqpDcf7Sm1SMJdby1/+Y+6f3Yt3/3PMcSTKPJNJ0=" ];
  };

  nixpkgs.overlays = [ inputs.niri-nix.overlays.niri-nix ];

  # Set Niri as the default session for your Display Manager
  services.displayManager.defaultSession = "niri";

  # Core Flake deployment hooks
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  home-manager.sharedModules = [
    (_: {
      imports = [
        inputs.niri-nix.homeModules.niri-nix
      ];
      
      # This empty set satisfies the module validator to prevent the null-error,
      # ensuring your native KDL string below generates seamlessly.
      wayland.windowManager.niri.settings = {};

      # =====================================================================
      # 🎛️ NIRI NATIVE KDL CONFIGURATION (All settings managed here)
      # =====================================================================
      wayland.windowManager.niri.config = ''
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
               DMS_DISABLE_MATUGEN "1"
           }

           // 🚀 SPAWN ON STARTUP / AUTOSTART DAEMONS
           spawn-at-startup "wlsunset" "-T" "4200" "-t" "4200"

           // ⌨️ HARDWARE INPUT & TOUCHPAD MANAGEMENT
           input {
               keyboard {
                   xkb {
                       layout "us,in"
                   }
                   repeat-delay 275
                   repeat-rate 35
                   track-layout "global"
               }
               touchpad {
                   natural-scroll false
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
           workspaces {
               name "1"
               name "2"
               name "3"
           }

           // 📐 LAYOUT STYLE & WINDOW GAPS
           layout {
               gaps 9
               center-focused-column "never"
               background-color "transparent"
               border {
                   enable
                   width 2
                   active-color "#ca9ee6"
                   inactive-color "#b4befe"
               }
               preset-column-widths {
                   proportion 0.33333
                   proportion 0.5
                   proportion 0.66667
               }
           }

           

           // 🎛️ LAYER RULES (Desktop Shell: DMS & Rofi)
           layer-rule {
               match namespace=r#"^dms:.*"#
               match namespace=r#"^rofi$"#
               geometry-corner-radius 12

               background-effect {
                   blur true
                   xray false
                   radius 10
                   noise 0.03
                   saturation 1.25
               } 
            }

           

           // 🖼️ WINDOW RULES & TRANSPARENCY
           window-rule {
               match app-id="^firefox$"
               match app-id="^zen-beta"
               match app-id="^floorp$"
               match app-id="^brave-"
               match app-id="^vlc$"
               match app-id="^easyeffects$"
               match app-id="^gapless$"
               opacity 1.0
            }

           window-rule {
               match app-id="^kitty$"
               match app-id="^com.mitchellh.ghostty$"
               match app-id="^Alacritty$"
               match app-id="^org.wezfurlong.wezterm$"
               match app-id="^nvim-wrapper$"
               match app-id="^VSCodium$"
               match app-id="^code$"
               opacity 0.94
               draw-border-with-background false
           }

           window-rule {
               match app-id="^gnome-disks$"
               match app-id="^org.gnome.Nautilus$"
               match app-id="^thunar$"
               match app-id="^pcmanfm$"
               match app-id="^file-roller$"
               match app-id="^steamwebhelper$"
               match app-id="^Spotify$"
               match app-id="^com.github.th_ch.youtube_music$"
               opacity 0.90
               draw-border-with-background false
           }

           window-rule {
               match app-id="^Emacs$"
               match app-id="^obsidian$"
               match app-id="^proton.vpn.app.gtk$"
               match app-id="^heroic$"
               match app-id="^lutris$"
               match app-id="^discord$"
               match app-id="^webcord$"
               match app-id="^vesktop$"
               opacity 0.90
               draw-border-with-background false
           }

           window-rule {
               match app-id="^pavucontrol$"
               match app-id="^blueman-manager$"
               match app-id="^nm-applet$"
               match app-id="^nm-connection-editor$"
               match app-id="^nwg-look$"
               match app-id="^qt5ct$"
               match app-id="^qt6ct$"
               match app-id="^yad$"
               match app-id="^app.drey.Warp$"
               match app-id="^net.davidotek.pupgui2$"
               match app-id="^Signal$"
               match app-id="^io.gitlab.theevilskeleton.Upscaler$"
               match app-id="^eog$"
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
               "Mod+Shift+E" { spawn "dms" "ipc" "call" "session" "toggle"; }
               "Mod+Backspace" { spawn "sh" "-c" "pkill -x wlogout || wlogout -b 4"; }
               "Mod+Shift+S" { spawn "spotify"; }
               "Mod+Shift+Y" { spawn "youtube-music"; }
               "Ctrl+Alt+Delete" { spawn "ghostty" "-e" "btop"; }
               "Mod+Ctrl+C" { spawn "hyprpicker" "--autocopy" "--format=hex"; }
               "Mod+F9" { spawn "wlsunset-toggle"; }
               "Mod+F10" { spawn "sh" "-c" "pkill wlsunset"; }
               
               "Mod+Left" { focus-column-left; }
               "Mod+Right" { focus-column-right; }
               "Mod+H" { focus-column-left; }
               "Mod+L" { focus-column-right; }
               "Mod+S" { toggle-overview; }
               "Mod+Ctrl+Left" { move-column-left; }
               "Mod+Ctrl+Right" { move-column-right; }
               
               "Mod+K" { focus-window-up; }
               "Mod+J" { focus-window-down; }
               "Mod+Ctrl+K" { move-column-to-workspace-up; }
               "Mod+Ctrl+J" { move-column-to-workspace-down; }
               "Mod+WheelScrollDown" { focus-workspace-down; }
               "Mod+WheelScrollUp" { focus-workspace-up; }

               "Mod+R" { switch-preset-column-width; }
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
    })
  ];
}