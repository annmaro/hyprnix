{
  host,
  lib,
  pkgs,
  ...
}:
let
  inherit (import ../../../hosts/${host}/variables.nix)
    browser
    terminal
    tuiFileManager
    kbdLayout
    kbdVariant
    ;
  autoclicker = pkgs.callPackage ./scripts/autoclicker.nix { };
in
{
  imports = [
    ../../themes/Catppuccin
    ./programs/waybar
    ./programs/wlogout
    ./programs/rofi
    ./programs/hypridle
    ./programs/hyprlock
    ./programs/awww
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
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    xdgOpenUsePortal = true;
  };

  programs.hyprland.enable = true;

  home-manager.sharedModules = [
    ({ ... }:
      let
        inherit (lib) getExe getExe';
        termExe = "${getExe pkgs.${terminal}}";
        editorExe = "code --disable-gpu";
        fileManagerExe = "${termExe} --class \"tuiFileManager\" -e ${tuiFileManager}";
      in
      {
        home.packages = with pkgs; [
          hyprpicker cliphist grimblast swappy libnotify brightnessctl
          networkmanagerapplet pamixer pavucontrol playerctl
          waybar wtype wl-clipboard xdotool yad
        ];

        xdg.configFile."hypr/icons" = {
          source = ./icons;
          recursive = true;
        };

        wayland.windowManager.hyprland = {
          enable = true;
          systemd = {
            enable = true;
            variables = [ "--all" ];
          };

          extraConfig = ''
            env = XDG_CURRENT_DESKTOP,Hyprland
            env = XDG_SESSION_DESKTOP,Hyprland
            env = XDG_SESSION_TYPE,wayland
            env = GDK_BACKEND,wayland,x11,*
            env = NIXOS_OZONE_WL,1
            env = ELECTRON_OZONE_PLATFORM_HINT,auto
            env = MOZ_ENABLE_WAYLAND,1
            env = QT_QPA_PLATFORM,wayland;xcb
            env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
            env = QT_QPA_PLATFORMTHEME,qt6ct
            env = QT_AUTO_SCREEN_SCALE_FACTOR,1.25

            exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
            exec-once = gnome-keyring-daemon --start --components=secrets,ssh,pkcs11
            exec-once = waybar
            exec-once = swaync
            exec-once = nm-applet --indicator
            exec-once = ${getExe pkgs.hyprsunset} --temperature 3000
            exec-once = ${getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch cliphist store
            exec-once = ${getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch cliphist store
            exec-once = ${./scripts/batterynotify.sh}
            exec-once = ${./scripts/autowaybar.sh}
            exec-once = pamixer --set-volume 50

            input {
              kb_layout = ${kbdLayout},ru
              kb_variant = ${kbdVariant},
              repeat_delay = 275
              repeat_rate = 35
              numlock_by_default = true
              follow_mouse = 1
              sensitivity = 0
              accel_profile = flat
              touchpad {
                natural_scroll = false
              }
            }

            general {
              gaps_in = 4
              gaps_out = 9
              border_size = 2
              col.active_border = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg
              col.inactive_border = rgba(b4befecc) rgba(6c7086cc) 45deg
              resize_on_border = true
              layout = dwindle
            }

            decoration {
              rounding = 10
              dim_special = 0.3
              blur {
                enabled = true
                special = true
                size = 6
                passes = 2
                ignore_opacity = true
                xray = false
              }
              shadow {
                enabled = false
              }
            }

            group {
              col.active_border = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg
              col.inactive_border = rgba(b4befecc) rgba(6c7086cc) 45deg
              col.border_locked_active = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg
            }

            animations {
              enabled = true
              bezier = md3_decel, 0.05, 0.7, 0.1, 1
              bezier = easeOutExpo, 0.16, 1, 0.3, 1
              animation = windows, 1, 3, md3_decel, popin 60%
              animation = border, 1, 10, default
              animation = fade, 1, 2.5, md3_decel
              animation = workspaces, 1, 3.5, easeOutExpo, slide
            }

            misc {
              force_default_wallpaper = 0
              disable_hyprland_logo = true
              vfr = true
              vrr = 2
            }

            render {
              direct_scanout = 2
            }

            windowrulev2 = noanim, class:^(Rofi)$
            windowrulev2 = tile, title:(.*)(Godot)(.*)$
            windowrulev2 = opacity 0.80 0.80, class:^(kitty|alacritty|Alacritty|org.wezfurlong.wezterm)$
            windowrulev2 = opacity 0.80 0.80, class:^(nvim-wrapper|tuiFileManager)$
            windowrulev2 = opacity 1.00 1.00, class:^(firefox)$
            windowrulev2 = opacity 0.80 0.70, class:^(pavucontrol|blueman-manager|nm-applet)$
            windowrulev2 = float, class:^(qt5ct|nwg-look|org.kde.ark|Signal|yad|pavucontrol)$
            windowrulev2 = tag +games, class:^(steam_app.*|gamescope|Waydroid|osu!)$
            windowrulev2 = content game, tag:games
            windowrulev2 = fullscreen, tag:games
            windowrulev2 = noanim, tag:games

            layerrule = blur, swaync-control-center
            layerrule = blur, swaync-notification-window
            layerrule = ignorealpha 0.7, swaync-control-center

            bind = SUPER, Return, exec, ${termExe}
            bind = SUPER, E, exec, ${fileManagerExe}
            bind = SUPER, C, exec, ${editorExe}
            bind = SUPER, F, exec, ${browser}
            bind = SUPER, Q, exec, ${./scripts/dontkillsteam.sh}
            bind = SUPER, W, togglefloating
            bind = SUPER, S, togglespecialworkspace,
            bind = SUPER, G, exec, launcher games
            bind = SUPER, V, exec, ${./scripts/ClipManager.sh}
            bind = SUPER, P, exec, ${./scripts/screenshot.sh} s
            bind = SUPER, left, movefocus, l
            bind = SUPER, right, movefocus, r
            bind = SUPER, up, movefocus, u
            bind = SUPER, down, movefocus, d

            ${builtins.concatStringsSep "\n" (builtins.genList (x: 
              let ws = toString (if (x + 1) == 10 then 0 else x + 1);
              in ''
                bind = SUPER, ${ws}, workspace, ${toString (x + 1)}
                bind = SUPER SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
              ''
            ) 10)}

            binde = ,XF86AudioRaiseVolume, exec, pamixer -i 2
            binde = ,XF86AudioLowerVolume, exec, pamixer -d 2
            binde = ,XF86MonBrightnessUp, exec, brightnessctl set +2%
            binde = ,XF86MonBrightnessDown, exec, brightnessctl set 2%-

            bindm = SUPER, mouse:272, movewindow
            bindm = SUPER, mouse:273, resizewindow
          '';
        };
      })
  ];
}