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
    # Define the autoclicker package path here so it's accessible everywhere below!
  autoclicker = pkgs.callPackage ./scripts/autoclicker.nix { };
in
{
  imports = [
    ../../themes/Catppuccin # Catppuccin GTK and QT themes
    ./programs/waybar
    #./programs/hyprpanel
    ./programs/wlogout
    ./programs/rofi
    ./programs/hypridle
    ./programs/hyprlock
    ./programs/awww
    ./programs/swaync
    # ./programs/dunst
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

  programs.hyprland = {
    enable = true;
    # withUWSM = true;
  };

  home-manager.sharedModules =
    let
      inherit (lib) getExe getExe';
      termExe = "${getExe pkgs.${terminal}}";
      editorExe = "code --disable-gpu";
      fileManagerExe = "${termExe} --class \"tuiFileManager\" -e ${tuiFileManager}";
    in
    [
      (
        { ... }:
        {
          home.packages = with pkgs; [
            hyprpicker
            cliphist
            grimblast
            swappy
            libnotify
            brightnessctl
            networkmanagerapplet
            pamixer
            pavucontrol
            playerctl
            waybar
            wtype
            wl-clipboard
            xdotool
            yad
          ];

          xdg.configFile."hypr/icons" = {
            source = ./icons;
            recursive = true;
          };

          wayland.windowManager.hyprland = {
            enable = true;
            plugins = [];
            system = {
              enable = true;
              variables = [ "--all" ];
            };
            
            # This structured settings block will automatically compile 
            # down into the correct, compliant hyprland.lua file format.
            settings = {
              # Defined directly via standard Nix strings—no legacy $ variables!
              env = [
                "XDG_CURRENT_DESKTOP,Hyprland"
                "XDG_SESSION_DESKTOP,Hyprland"
                "XDG_SESSION_TYPE,wayland"
                "GDK_BACKEND,wayland,x11,*"
                "NIXOS_OZONE_WL,1"
                "ELECTRON_OZONE_PLATFORM_HINT,auto"
                "MOZ_ENABLE_WAYLAND,1"
                "OZONE_PLATFORM,wayland"
                "EGL_PLATFORM,wayland"
                "CLUTTER_BACKEND,wayland"
                "SDL_VIDEODRIVER,wayland"
                "QT_QPA_PLATFORM,wayland;xcb"
                "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
                "QT_QPA_PLATFORMTHEME,qt6ct"
                "QT_AUTO_SCREEN_SCALE_FACTOR,1.25"
                "WLR_RENDERER_ALLOW_SOFTWARE,1"
                "NIXPKGS_ALLOW_UNFREE,1"
              ];

              exec-once = [
                "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
                "dbus-update-activation-environment --all" 
                "gnome-keyring-daemon --start --components=secrets,ssh,pkcs11"
                "waybar"
                "swaync"
                "nm-applet --indicator"
                "wl-clipboard-history -t"
                "${getExe pkgs.hyprsunset} --temperature 3000"
                "${getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch cliphist store"
                "${getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch cliphist store"
                "rm '$XDG_CACHE_HOME/cliphist/db'"
                "${./scripts/batterynotify.sh}"
                "${./scripts/autowaybar.sh}"
                "polkit-agent-helper-1"
                "pamixer --set-volume 50"
              ];

              input = {
                kb_layout = "${kbdLayout},ru";
                kb_variant = "${kbdVariant},";
                repeat_delay = 275;
                repeat_rate = 35;
                numlock_by_default = true;
                follow_mouse = 1;
                touchpad.natural_scroll = false;
                tablet.output = "current";
                sensitivity = 0;
                force_no_accel = true;
              };

              general = {
                gaps_in = 4;
                gaps_out = 9;
                border_size = 2;
                "col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
                "col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
                resize_on_border = true;
                layout = "dwindle";
              };

              decoration = {
                shadow.enabled = false;
                rounding = 10;
                dim_special = 0.3;
                blur = {
                  enabled = true;
                  special = true;
                  size = 6;
                  passes = 2;
                  new_optimizations = true;
                  ignore_opacity = true;
                  xray = false;
                };
              };

              group = {
                "col.border_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
                "col.border_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
                "col.border_locked_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
                "col.border_locked_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
              };

              layerrule = [
                "blur on, match:namespace swaync-control-center"
                "blur on, match:namespace swaync-notification-window"
                "ignore_alpha 0.7, match:namespace swaync-control-center"
              ];

              animations = {
                enabled = true;
                bezier = [
                  "linear, 0, 0, 1, 1"
                  "md3_standard, 0.2, 0, 0, 1"
                  "md3_decel, 0.05, 0.7, 0.1, 1"
                  "md3_accel, 0.3, 0, 0.8, 0.15"
                  "overshot, 0.05, 0.9, 0.1, 1.1"
                  "crazyshot, 0.1, 1.5, 0.76, 0.92"
                  "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
                  "fluent_decel, 0.1, 1, 0, 1"
                  "easeInOutCirc, 0.85, 0, 0.15, 1"
                  "easeOutCirc, 0, 0.55, 0.45, 1"
                  "easeOutExpo, 0.16, 1, 0.3, 1"
                ];
                animation = [
                  "windows, 1, 3, md3_decel, popin 60%"
                  "border, 1, 10, default"
                  "fade, 1, 2.5, md3_decel"
                  "workspaces, 1, 3.5, easeOutExpo, slide"
                  "specialWorkspace, 1, 3, md3_decel, slidevert"
                ];
              };

              render = {
                direct_scanout = 2;
              };

              ecosystem = {
                no_update_news = true;
                no_donation_nag = true;
              };

              misc = {
                force_default_wallpaper = 0;
                disable_hyprland_logo = true;
                disable_splash_rendering = true;
                mouse_move_focuses_monitor = true;
                swallow_regex = "^(Alacritty|kitty)$";
                enable_swallow = true;
                vfr = true;
                vrr = 2;
              };

              xwayland.force_zero_scaling = false;
              gesture = [
                "3, horizontal, workspace"
              ];

              dwindle = {
                pseudotile = true;
                preserve_split = true;
              };

              master = {
                new_status = "master";
                new_on_top = true;
                mfact = 0.5;
              };

              windowrule = [
                "no_anim on,match:class ^(Rofi)$"
                "tile on,match:title (.*)(Godot)(.*)$"
                "opacity 0.80 0.80,match:class ^(kitty|alacritty|Alacritty|org.wezfurlong.wezterm)$"
                "opacity 0.80 0.80,match:class ^(nvim-wrapper)$"
                "opacity 0.90 0.90,match:class ^(gcr-prompter)$"
                "opacity 0.90 0.90,match:title ^(Hyprland Polkit Agent)$"
                "opacity 1.00 1.00,match:class ^(firefox)$"
                "opacity 0.90 0.90,match:class ^(Brave-browser)$"
                "opacity 0.80 0.80,match:class ^(org.gnome.Nautilus|thunar)$"
                "opacity 0.80 0.80,match:class ^(Steam)$"
                "opacity 0.80 0.80,match:class ^(steam)$"
                "opacity 0.80 0.80,match:class ^(steamwebhelper)$"
                "opacity 0.80 0.80,match:class ^(Spotify)$"
                "opacity 0.80 0.80,match:title (.*)(Spotify)(.*)$"
                "opacity 0.80 0.80,match:class ^(VSCodium)$"
                "opacity 0.80 0.80,match:class ^(codium-url-handler)$"
                "opacity 0.80 0.80,match:class ^(code)$"
                "opacity 0.80 0.80,match:class ^(code-url-handler)$"
                "opacity 0.80 0.80,match:class ^(tuiFileManager)$"
                "opacity 0.80 0.80,match:class ^(org.kde.dolphin)$"
                "opacity 0.80 0.80,match:class ^(org.kde.ark)$"
                "opacity 0.80 0.80,match:class ^(nwg-look)$"
                "opacity 0.80 0.80,match:class ^(qt5ct)$"
                "opacity 0.80 0.80,match:class ^(qt6ct)$"
                "opacity 0.80 0.80,match:class ^(yad)$"
                "opacity 0.90 0.90,match:class ^(com.github.rafostar.Clapper)$"
                "opacity 0.80 0.80,match:class ^(com.github.tchx84.Flatseal)$"
                "opacity 0.80 0.80,match:class ^(hu.kramo.Cartridges)$"
                "opacity 0.80 0.80,match:class ^(com.obsproject.Studio)$"
                "opacity 0.80 0.80,match:class ^(gnome-boxes)$"
                "opacity 0.90 0.90,match:class ^(discord)$"
                "opacity 0.90 0.90,match:class ^(WebCord)$"
                "opacity 0.80 0.80,match:class ^(app.drey.Warp)$"
                "opacity 0.80 0.80,match:class ^(net.davidotek.pupgui2)$"
                "opacity 0.80 0.80,match:class ^(Signal)$"
                "opacity 0.80 0.80,match:class ^(io.gitlab.theevilskeleton.Upscaler)$"
                "opacity 0.80 0.70,match:class ^(pavucontrol)$"
                "opacity 0.80 0.70,match:class ^(org.pulseaudio.pavucontrol)$"
                "opacity 0.80 0.70,match:class ^(blueman-manager)$"
                "opacity 0.80 0.70,match:class ^(.blueman-manager-wrapped)$"
                "opacity 0.80 0.70,match:class ^(nm-applet)$"
                "opacity 0.80 0.70,match:class ^(nm-connection-editor)$"
                "opacity 0.80 0.70,match:class ^(org.kde.polkit-kde-authentication-agent-1)$"
                "content game, match:tag games"
                "tag +games,  match:content game"
                "tag +games, match:class ^(steam_app.*|steam_app_\\d+)$"
                "tag +games, match:class ^(gamescope)$"
                "tag +games, match:class ^(Waydroid)"
                "tag +games, match:class ^(osu!)"
                "sync_fullscreen on,match:tag games"
                "fullscreen on,match:tag games"
                "border_size 1,match:tag sames"
                "no_shadow on,match:tag games"
                "no_blur on,match:tag games"
                "no_anim on,match:tag games"
                "float true,match:class ^(qt5ct)$"
                "float true,match:class ^(nwg-look)$"
                "float true,match:class ^(org.kde.ark)$"
                "float true,match:class ^(Signal)$"
                "float true,match:class ^(com.github.rafostar.Clapper)$"
                "float true,match:class ^(app.drey.Warp)$"
                "float true,match:class ^(net.davidotek.pupgui2)$"
                "float true,match:class ^(eog)$"
                "float true,match:class ^(io.gitlab.theevilskeleton.Upscaler)$"
                "float true,match:class ^(yad)$"
                "float true,match:class ^(pavucontrol)$"
                "float true,match:class ^(blueman-manager)$"
                "float true,match:class ^(.blueman-manager-wrapped)$"
                "float true,match:class ^(nm-applet)$"
                "float true,match:class ^(nm-connection-editor)$"
                "float true,match:class ^(org.kde.polkit-kde-authentication-agent-1)$"
              ];

              binde = [
                "SUPER SHIFT, right, resizeactive, 30 0"
                "SUPER SHIFT, left, resizeactive, -30 0"
                "SUPER SHIFT, up, resizeactive, 0 -30"
                "SUPER SHIFT, down, resizeactive, 0 30"
                "SUPER SHIFT, l, resizeactive, 30 0"
                "SUPER SHIFT, h, resizeactive, -30 0"
                "SUPER SHIFT, k, resizeactive, 0 -30"
                "SUPER SHIFT, j, resizeactive, 0 30"
                ",XF86MonBrightnessDown,exec,brightnessctl set 2%-"
                ",XF86MonBrightnessUp,exec,brightnessctl set +2%"
                ",XF86AudioLowerVolume,exec,pamixer -d 2"
                ",XF86AudioRaiseVolume,exec,pamixer -i 2"
              ];

              bind = [
                "SUPER, question, exec, ${./scripts/keybinds.sh}"
                "SUPER, slash, exec, ${./scripts/keybinds.sh}"
                "SUPER CTRL, K, exec, ${./scripts/keybinds.sh}"
                "SUPER, F8, exec, kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || ${lib.getExe autoclicker} --cps 40"
                "SUPER, F9, exec, ${getExe pkgs.hyprsunset} --temperature 3000"
                "SUPER, F10, exec, pkill hyprsunset"
                "SUPER, Q, exec, ${./scripts/dontkillsteam.sh}"
                "ALT, F4, exec, ${./scripts/dontkillsteam.sh}"
                "SUPER, delete, exit"
                "SUPER, W, togglefloating"
                "SUPER SHIFT, G, togglegroup"
                "ALT, return, fullscreen"
                "SUPER ALT, L, exec, hyprlock"
                "SUPER, backspace, exec, pkill -x wlogout || wlogout -b 4"
                "CTRL, ESCAPE, exec, pkill waybar || waybar"
                "SUPER, Return, exec, ${termExe}"
                "SUPER, T, exec, ${termExe}"
                "SUPER, E, exec, ${fileManagerExe}"
                "SUPER, C, exec, ${editorExe}"
                "SUPER, F, exec, ${browser}"
                "SUPER SHIFT, S, exec, spotify"
                "SUPER SHIFT, Y, exec, youtube-music"
                "CTRL ALT, DELETE, exec, ${termExe} -e '${getExe pkgs.btop}'"
                "SUPER CTRL, C, exec, hyprpicker --autocopy --format=hex"
                "SUPER, A, exec, launcher drun"
                "SUPER, SPACE, exec, launcher drun"
                "SUPER, Z, exec, launcher emoji"
                "SUPER SHIFT, T, exec, launcher tmux"
                "SUPER, G, exec, launcher games"
                "SUPER ALT, K, exec, ${./scripts/keyboardswitch.sh}"
                "SUPER SHIFT, N, exec, swaync-client -t -sw"
                "SUPER SHIFT, Q, exec, swaync-client -t -sw"
                "SUPER ALT, G, exec, ${./scripts/gamemode.sh}"
                "SUPER, V, exec, ${./scripts/ClipManager.sh}"
                "SUPER, M, exec, ${./scripts/rofimusic.sh}"
                "SUPER, P, exec, ${./scripts/screenshot.sh} s"
                "SUPER CTRL, P, exec, ${./scripts/screenshot.sh} sf"
                "SUPER, print, exec, ${./scripts/screenshot.sh} m"
                "SUPER ALT, P, exec, ${./scripts/screenshot.sh} p"
                ",xf86Sleep, exec, systemctl suspend"
                ",XF86AudioMicMute,exec,pamixer --default-source -t"
                ",XF86AudioMute,exec,pamixer -t"
                ",XF86AudioPlay,exec,playerctl play-pause"
                ",XF86AudioPause,exec,playerctl play-pause"
                ",xf86AudioNext,exec,playerctl next"
                ",xf86AudioPrev,exec,playerctl previous"
                "SUPER, Tab, cyclenext"
                "SUPER, Tab, bringactivetotop"
                "SUPER CTRL, right, workspace, r+1"
                "SUPER CTRL, left, workspace, r-1"
                "SUPER CTRL, down, workspace, empty"
                "SUPER, left, movefocus, l"
                "SUPER, right, movefocus, r"
                "SUPER, up, movefocus, u"
                "SUPER, down, movefocus, d"
                "ALT, Tab, movefocus, d"
                "SUPER, h, movefocus, l"
                "SUPER, l, movefocus, r"
                "SUPER, k, movefocus, u"
                "SUPER, j, movefocus, d"
                "SUPER, mouse:276, workspace, 5"
                "SUPER, mouse:275, workspace, 6"
                "SUPER SHIFT, mouse:276, movetoworkspace, 5"
                "SUPER SHIFT, mouse:275, movetoworkspace, 6"
                "SUPER CTRL, mouse:276, movetoworkspacesilent, 5"
                "SUPER CTRL, mouse:275, movetoworkspacesilent, 6"
                "SUPER, U, exec, ${termExe} -e rebuild"
                "SUPER, mouse_down, workspace, e+1"
                "SUPER, mouse_up, workspace, e-1"
                "SUPER CTRL ALT, right, movetoworkspace, r+1"
                "SUPER CTRL ALT, left, movetoworkspace, r-1"
                "SUPER SHIFT CTRL, left, movewindow, l"
                "SUPER SHIFT CTRL, right, movewindow, r"
                "SUPER SHIFT CTRL, up, movewindow, u"
                "SUPER SHIFT CTRL, down, movewindow, d"
                "SUPER SHIFT CTRL, H, movewindow, l"
                "SUPER SHIFT CTRL, L, movewindow, r"
                "SUPER SHIFT CTRL, K, movewindow, u"
                "SUPER SHIFT CTRL, J, movewindow, d"
                "SUPER CTRL, S, movetoworkspacesilent, special"
                "SUPER ALT, S, movetoworkspacesilent, special"
                "SUPER, S, togglespecialworkspace,"
              ] ++ (builtins.concatLists (
                builtins.genList (
                  x:
                  let
                    ws =
                      let
                        c = (x + 1) / 10;
                      in
                      builtins.toString (x + 1 - (c * 10));
                  in
                  [
                    "SUPER, ${ws}, workspace, ${toString (x + 1)}"
                    "SUPER SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                    "SUPER CTRL, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
                  ]
                ) 10
              ));

              bindm = [
                "SUPER, mouse:272, movewindow"
                "SUPER, mouse:273, resizewindow"
              ];

              binds = {
                workspace_back_and_forth = 0;
              };

              monitor = [
                ",preferred,auto,1"
                "desc:BNQ BenQ EW277HDR 99J01861SL0,preferred,-1920x0,1"
                "desc:BNQ BenQ EL2870U PCK00489SL0,preferred,0x0,2"
                "desc:BNQ BenQ xl2420t 99D06760SL0,preferred,1920x-420,1,transform,1"
              ];

              workspace = [
                "1,monitor:desc:BNQ BenQ EL2870U PCK00489SL0,default:true"
                "2,monitor:desc:BNQ BenQ EL2870U PCK00489SL0"
                "3,monitor:desc:BNQ BenQ EL2870U PCK00489SL0"
                "4,monitor:desc:BNQ BenQ EL2870U PCK00489SL0"
                "5,monitor:desc:BNQ BenQ EW277HDR 99J01861SL0,default:true"
                "6,monitor:desc:BNQ BenQ EW277HDR 99J01861SL0"
                "7,monitor:desc:BNQ BenQ EW277HDR 99J01861SL0"
                "8,monitor:desc:BNQ BenQ xl2420t 99D06760SL0,default:true"
                "9,monitor:desc:BNQ BenQ xl2420t 99D06760SL0"
                "10,monitor:desc:BNQ BenQ EL2870U PCK00489SL0"
              ];
            };
          };
        }
      )
    ];
}