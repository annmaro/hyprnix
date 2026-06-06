{
  config,
  pkgs,
  getExe,
  kbdLayout,
  kbdVariant,
  wallpaper,
  keybindsRofi,
}:

let
  kdlFlag = self: { custom = args: "${args.indent}\"${args.name}\""; };
in
{
  prefer-no-csd = kdlFlag;
  hotkey-overlay.skip-at-startup = kdlFlag;

  environment = {
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland,x11,*";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    OZONE_PLATFORM = "wayland";
    EGL_PLATFORM = "wayland";
    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    NIXPKGS_ALLOW_UNFREE = "1";
    DMS_DISABLE_MATUGEN = "0";
  };

  spawn-at-startup = [
    [
      "sh"
      "-c"
      "sleep 1 && wlsunset -T 3800 -t 3799"
    ]
    [
      "sh"
      "-c"
      "sleep 2 && thunar --daemon"
    ]
    [ "${getExe wallpaper}" ]
  ];

  input = {
    keyboard = {
      xkb = {
        layout = "${kbdLayout}";
        variant = "${kbdVariant}";
      };
      repeat-delay = 275;
      repeat-rate = 35;
      track-layout = "global";
    };
    touchpad = {
      click-method = "clickfinger";
    };
    mouse = {
      accel-profile = "flat";
      accel-speed = 0.0;
    };
    warp-mouse-to-focus = kdlFlag;
    focus-follows-mouse = kdlFlag;
  };

  outputs."desc:BOE 0x0690" = {
    mode = "1920x1080@60.014";
    scale = 1.0;
  };

  workspaces = {
    "1" = { };
    "2" = { };
  };

  blur = {
    passes = 3;
    offset = 3.0;
    noise = 0.02;
    saturation = 1.1;
  };

  layout = {
    gaps = 9;
    center-focused-column = "never";
    background-color = "transparent";
    border = {
      width = 1;
      active-color = "#${config.lib.stylix.colors.base0D}";
      inactive-color = "transparent";
    };
    preset-column-widths = [
      { proportion = 0.33333; }
      { proportion = 0.5; }
      { proportion = 0.66667; }
    ];
  };

  layer-rules = [
    {
      matches = [ { namespace = "^awww-daemonoverlay$"; } ];
      place-within-backdrop = true;
    }
    {
      matches = [ { namespace = "^rofi$"; } ];
      geometry-corner-radius = 12.0;
      background-effect = {
        blur = true;
        xray = false;
        noise = 0.03;
        saturation = 1.25;
      };
    }
    {
      matches = [ { namespace = "^dms:.*"; } ];
      background-effect = {
        xray = false;
      };
    }
  ];

  overview = {
    # workspace-shadow.enable = false; # wrapper-modules does not parse this directly
  };

  window-rules = [
    {
      geometry-corner-radius = 12.0;
      clip-to-geometry = true;
    }
    {
      matches = [ { app-id = "^(firefox|zen-beta|floorp|brave-|vlc|easyeffects|gapless)$"; } ];
      open-maximized = true;
      opacity = 1.0;
    }
    {
      matches = [
        { app-id = "^(kitty|neovim|com.mitchellh.ghostty|Alacritty|org.wezfurlong.wezterm)$"; }
      ];
      opacity = 0.80;
      background-effect = {
        blur = true;
        xray = false;
      };
    }
    {
      matches = [
        {
          app-id = "^(gnome-disks|org.gnome.Nautilus|pcmanfm|file-roller|steamwebhelper|spotify|com.github.th_ch.youtube_music)$";
        }
      ];
      opacity = 0.70;
      background-effect = {
        blur = true;
        xray = false;
      };
    }
    {
      matches = [
        {
          app-id = "^(Emacs|obsidian|proton.vpn.app.gtk|heroic|lutris|discord|webcord|vesktop|neovim|nvim-wrapper|antigravity|VSCodium|code|thunar)$";
        }
      ];
      opacity = 0.85;
      background-effect = {
        blur = true;
        xray = false;
      };
    }
    {
      matches = [
        {
          app-id = "^(pavucontrol|blueman-manager|nm-applet|nm-connection-editor|nwg-look|qt5ct|qt6ct|yad|app.drey.Warp|net.davidotek.pupgui2|Signal|io.gitlab.theevilskeleton.Upscaler|eog)$";
        }
      ];
      open-floating = true;
    }
    {
      matches = [ { title = "^Picture-in-Picture$"; } ];
      open-floating = true;
    }
  ];

  binds = {
    "Mod+Return".spawn = "ghostty";
    "Mod+T".spawn = "kitty";
    "Mod+C".spawn = "editor";
    "Mod+F".spawn = "firefox";
    "Mod+A".spawn = "antigravity";
    "Mod+Space".spawn = [
      "rofi"
      "-show"
      "drun"
    ];
    "Mod+V".spawn = [
      "rofi"
      "-show"
      "clipboard"
    ];
    "Mod+Z".spawn = [
      "rofi"
      "-show"
      "emoji"
    ];
    "Mod+Shift+K".spawn = "${getExe keybindsRofi}";
    "Mod+G".spawn = [
      "launcher"
      "games"
    ];
    "Mod+Alt+G".spawn = "gamemode";
    "Alt+F4".close-window = kdlFlag;
    "Ctrl+Q".close-window = kdlFlag;
    "Alt+S".spawn = [
      "systemctl"
      "--user"
      "restart"
      "dms"
    ];
    "Mod+Delete".quit = kdlFlag;
    "Mod+Alt+L".spawn = [
      "dms"
      "session"
      "lock"
    ];
    "Mod+N".spawn = [
      "dms"
      "ipc"
      "call"
      "notifications"
      "toggle"
    ];
    "Mod+D".spawn = [
      "eww"
      "open"
      "--toggle"
      "dashboard"
    ];
    "Mod+Shift+E".spawn = [
      "dms"
      "ipc"
      "call"
      "session"
      "toggle"
    ];
    "Mod+Shift+C".spawn = "code";
    "Mod+Shift+R".spawn = [
      "sh"
      "-c"
      "thunar -q && thunar --daemon"
    ];
    "Mod+Backspace".spawn = [
      "sh"
      "-c"
      "pkill -x wlogout || wlogout -b 4"
    ];
    "Mod+Shift+S".spawn = "spotify";
    "Mod+Shift+P".spawn = "rofi-powermenu";
    "Mod+Shift+Y".spawn = "youtube-music";
    "Ctrl+Alt+Delete".spawn = [
      "ghostty"
      "-e"
      "btop"
    ];
    "Mod+Ctrl+C".spawn = [
      "hyprpicker"
      "--autocopy"
      "--format=hex"
    ];
    "Mod+F9".spawn = [
      "sh"
      "-c"
      "wlsunset -T 3800 -t 3799"
    ];
    "Mod+F10".spawn = [
      "sh"
      "-c"
      "pkill -9 wlsunset || killall -9 wlsunset"
    ];

    "Mod+Left".focus-column-left = kdlFlag;
    "Mod+Right".focus-column-right = kdlFlag;
    "Mod+H".focus-column-left = kdlFlag;
    "Mod+L".focus-column-right = kdlFlag;
    "Mod+S".spawn = [
      "sh"
      "-c"
      "niri msg action toggle-overview"
    ];
    "Mod+Ctrl+Left".move-column-left = kdlFlag;
    "Mod+Ctrl+Right".move-column-right = kdlFlag;

    "Mod+K".focus-window-up = kdlFlag;
    "Mod+J".focus-window-down = kdlFlag;
    "Mod+Ctrl+K".move-column-to-workspace-up = kdlFlag;
    "Mod+Ctrl+J".move-column-to-workspace-down = kdlFlag;
    "Mod+WheelScrollDown".focus-workspace-down = kdlFlag;
    "Mod+WheelScrollUp".focus-workspace-up = kdlFlag;

    "Mod+R".switch-preset-column-width = kdlFlag;
    "Mod+M".maximize-column = kdlFlag;
    "Alt+Return".fullscreen-window = kdlFlag;
    "Mod+W".toggle-window-floating = kdlFlag;
    "Mod+1".focus-workspace = 1;
    "Mod+2".focus-workspace = 2;
    "Mod+3".focus-workspace = 3;
    "Mod+Shift+1".move-column-to-workspace = 1;
    "Mod+Shift+2".move-column-to-workspace = 2;
    "Mod+Shift+3".move-column-to-workspace = 3;
    "Mod+Shift+4".move-column-to-workspace = 4;
    "Mod+Shift+5".move-column-to-workspace = 5;

    "XF86AudioRaiseVolume".spawn = [
      "pamixer"
      "-i"
      "2"
    ];
    "XF86AudioLowerVolume".spawn = [
      "pamixer"
      "-d"
      "2"
    ];
    "XF86AudioMute".spawn = [
      "pamixer"
      "-t"
    ];
    "XF86AudioMicMute".spawn = [
      "pamixer"
      "--default-source"
      "-t"
    ];
    "XF86MonBrightnessUp".spawn = [
      "brightnessctl"
      "set"
      "+2%"
    ];
    "XF86MonBrightnessDown".spawn = [
      "brightnessctl"
      "set"
      "2%-"
    ];
    "XF86AudioPlay".spawn = [
      "playerctl"
      "play-pause"
    ];
    "XF86AudioPause".spawn = [
      "playerctl"
      "play-pause"
    ];
    "XF86AudioNext".spawn = [
      "playerctl"
      "next"
    ];
    "XF86AudioPrev".spawn = [
      "playerctl"
      "previous"
    ];
    "XF86Sleep".spawn = [
      "systemctl"
      "suspend"
    ];
    "Mod+Up".focus-window-or-workspace-up = kdlFlag;
    "Mod+Down".focus-window-or-workspace-down = kdlFlag;
    "Mod+Ctrl+Up".move-workspace-up = kdlFlag;
    "Mod+Ctrl+Down".move-workspace-down = kdlFlag;
    "Mod+P".spawn = [
      "sh"
      "-c"
      "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -"
    ];
    "Mod+Ctrl+P".spawn = [
      "sh"
      "-c"
      "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -"
    ];
  };
}
