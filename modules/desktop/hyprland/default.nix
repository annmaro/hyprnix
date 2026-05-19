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

          settings = {
            env = [
              "XDG_CURRENT_DESKTOP,Hyprland"
              "XDG_SESSION_DESKTOP,Hyprland"
              "XDG_SESSION_TYPE,wayland"
              "GDK_BACKEND,wayland,x11,*"
              "NIXOS_OZONE_WL,1"
              "ELECTRON_OZONE_PLATFORM_HINT,auto"
              "MOZ_ENABLE_WAYLAND,1"
              "QT_QPA_PLATFORM,wayland;xcb"
              "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
              "QT_QPA_PLATFORMTHEME,qt6ct"
              "QT_AUTO_SCREEN_SCALE_FACTOR,1.25"
            ];

            # --- Initialization ---
            "exec-once" = [
              "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
              "gnome-keyring-daemon --start --components=secrets,ssh,pkcs11"
              "waybar"
              "swaync"
              "nm-applet --indicator"
              "${getExe pkgs.hyprsunset} --temperature 3000"
              "${getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch cliphist store"
              "${getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch cliphist store"
              "${./scripts/batterynotify.sh}"
              "${./scripts/autowaybar.sh}"
              "pamixer --set-volume 50"
            ];

            input = {
              kb_layout = "${kbdLayout},ru";
              kb_variant = "${kbdVariant},";
              repeat_delay = 275;
              repeat_rate = 35;
              numlock_by_default = true;
              follow_mouse = 1;
              sensitivity = 0;
              accel_profile = "flat"; # Modern replacement for force_no_accel
              touchpad.natural_scroll = false;
            };

            general = {
              gaps_in = 4;
              gaps_out = 9;
              border_size = 2;
              active_border = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
              inactive_border = "rgba(b4befecc) rgba(6c7086cc) 45deg";
              resize_on_border = true;
              layout = "dwindle";
            };

            decoration = {
              rounding = 10;
              dim_special = 0.3;
              blur = {
                enabled = true;
                special = true;
                size = 6;
                passes = 2;
                ignore_opacity = true;
                xray = false;
              };
              shadow = {
                enabled = false;
              };
            };

            group = {
              active_border = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
              inactive_border = "rgba(b4befecc) rgba(6c7086cc) 45deg";
              "col.border_locked_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg"; # col. remains for specific sub-fields in some versions
            };

            animations = {
              enabled = true;
              bezier = [
                "md3_decel, 0.05, 0.7, 0.1, 1"
                "easeOutExpo, 0.16, 1, 0.3, 1"
              ];
              animation = [
                "windows, 1, 3, md3_decel, popin 60%"
                "border, 1, 10, default"
                "fade, 1, 2.5, md3_decel"
                "workspaces, 1, 3.5, easeOutExpo, slide"
              ];
            };

            misc = {
              force_default_wallpaper = 0;
              disable_hyprland_logo = true;
              vfr = true;
              vrr = 2;
            };

            render.direct_scanout = 2;

            # --- Window Rules (V2) ---
            windowrulev2 = [
              "noanim, class:^(Rofi)$"
              "tile, title:(.*)(Godot)(.*)$"
              "opacity 0.80 0.80, class:^(kitty|alacritty|Alacritty|org.wezfurlong.wezterm)$"
              "opacity 0.80 0.80, class:^(nvim-wrapper|tuiFileManager)$"
              "opacity 1.00 1.00, class:^(firefox)$"
              "opacity 0.80 0.70, class:^(pavucontrol|blueman-manager|nm-applet)$"
              "float, class:^(qt5ct|nwg-look|org.kde.ark|Signal|yad|pavucontrol)$"
              
              # Tagging and Game Logic
              "tag +games, class:^(steam_app.*|gamescope|Waydroid|osu!)$"
              "content game, tag:games"
              "fullscreen, tag:games"
              "noanim, tag:games"
            ];

            layerrule = [
              "blur, swaync-control-center"
              "blur, swaync-notification-window"
              "ignorealpha 0.7, swaync-control-center"
            ];

            # --- Binds ---
            bind = [
              "SUPER, Return, exec, ${termExe}"
              "SUPER, E, exec, ${fileManagerExe}"
              "SUPER, C, exec, ${editorExe}"
              "SUPER, F, exec, ${browser}"
              "SUPER, Q, exec, ${./scripts/dontkillsteam.sh}"
              "SUPER, W, togglefloating"
              "SUPER, S, togglespecialworkspace,"
              "SUPER, G, exec, launcher games"
              "SUPER, V, exec, ${./scripts/ClipManager.sh}"
              "SUPER, P, exec, ${./scripts/screenshot.sh} s"
              "SUPER, left, movefocus, l"
              "SUPER, right, movefocus, r"
              "SUPER, up, movefocus, u"
              "SUPER, down, movefocus, d"
            ] ++ (builtins.concatLists (builtins.genList (x: 
              let ws = toString (if (x + 1) == 10 then 0 else x + 1); 
              in [
                "SUPER, ${ws}, workspace, ${toString (x + 1)}"
                "SUPER SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]) 10));

            binde = [
              ",XF86AudioRaiseVolume, exec, pamixer -i 2"
              ",XF86AudioLowerVolume, exec, pamixer -d 2"
              ",XF86MonBrightnessUp, exec, brightnessctl set +2%"
              ",XF86MonBrightnessDown, exec, brightnessctl set 2%-"
            ];

            bindm = [
              "SUPER, mouse:272, movewindow"
              "SUPER, mouse:273, resizewindow"
            ];
          };
        };
      })
  ];
}