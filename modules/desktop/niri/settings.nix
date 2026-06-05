{ config, pkgs, getExe, kbdLayout, kbdVariant, wallpaper, keybindsRofi }:

{
  prefer-no-csd = true;
  hotkey-overlay.skip-at-startup = true;

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
    { command = ["sh" "-c" "sleep 1 && wlsunset -T 3800 -t 3799"]; }
    { command = ["sh" "-c" "sleep 2 && thunar --daemon"]; }
    { command = ["${getExe wallpaper}"]; }
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
    warp-mouse-to-focus = true;
    focus-follows-mouse.enable = true;
  };

  outputs."desc:BOE 0x0690" = {
    mode = "1920x1080@60.014";
    scale = 1.0;
    position = { x = 0; y = 0; };
  };

  workspaces = {
    "1" = {};
    "2" = {};
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
      matches = [{ namespace = "^awww-daemonoverlay$"; }];
      place-within-backdrop = true;
    }
    {
      matches = [{ namespace = "^rofi$"; }];
      geometry-corner-radius = 12;
      background-effect = {
        blur = true;
        xray = false;
        noise = 0.03;
        saturation = 1.25;
      };
    }
    {
      matches = [{ namespace = "^dms:.*"; }];
      background-effect = {
        xray = false;
      };
    }
  ];

  overview = {
    workspace-shadow.enable = false;
  };

  window-rules = [
    {
      geometry-corner-radius = 12;
      clip-to-geometry = true;
    }
    {
      matches = [{ app-id = "^(firefox|zen-beta|floorp|brave-|vlc|easyeffects|gapless)$"; }];
      open-maximized-to-edges = true;
      draw-border-with-background = false;
      opacity = 1.0;
    }
    {
      matches = [{ app-id = "^(kitty|neovim|com.mitchellh.ghostty|Alacritty|org.wezfurlong.wezterm)$"; }];
      opacity = 0.80;
      draw-border-with-background = false;
      background-effect = {
        blur = true;
        xray = false;
      };
    }
    {
      matches = [{ app-id = "^(gnome-disks|org.gnome.Nautilus|pcmanfm|file-roller|steamwebhelper|spotify|com.github.th_ch.youtube_music)$"; }];
      opacity = 0.70;
      draw-border-with-background = false;
      background-effect = {
        blur = true;
        xray = false;
      };
    }
    {
      matches = [{ app-id = "^(Emacs|obsidian|proton.vpn.app.gtk|heroic|lutris|discord|webcord|vesktop|neovim|nvim-wrapper|antigravity|VSCodium|code|thunar)$"; }];
      opacity = 0.85;
      draw-border-with-background = false;
      background-effect = {
        blur = true;
        xray = false;
      };
    }
    {
      matches = [{ app-id = "^(pavucontrol|blueman-manager|nm-applet|nm-connection-editor|nwg-look|qt5ct|qt6ct|yad|app.drey.Warp|net.davidotek.pupgui2|Signal|io.gitlab.theevilskeleton.Upscaler|eog)$"; }];
      open-floating = true;
    }
    {
      matches = [{ title = "^Picture-in-Picture$"; }];
      open-floating = true;
    }
  ];

  binds = {
    "Mod+Return".action.spawn = "ghostty";
    "Mod+T".action.spawn = "kitty";
    "Mod+C".action.spawn = "editor";
    "Mod+F".action.spawn = "firefox";
    "Mod+A".action.spawn = "antigravity";
    "Mod+Space".action.spawn = ["rofi" "-show" "drun"];
    "Mod+V".action.spawn = ["rofi" "-show" "clipboard"];
    "Mod+Z".action.spawn = ["rofi" "-show" "emoji"];
    "Mod+Shift+K".action.spawn = "${getExe keybindsRofi}";
    "Mod+G".action.spawn = ["launcher" "games"];
    "Mod+Alt+G".action.spawn = "gamemode";
    "Alt+F4".action.close-window = [];
    "Ctrl+Q".action.close-window = [];
    "Alt+S".action.spawn = ["systemctl" "--user" "restart" "dms"];
    "Mod+Delete".action.quit = [];
    "Mod+Alt+L".action.spawn = ["dms" "session" "lock"];
    "Mod+N".action.spawn = ["dms" "ipc" "call" "notifications" "toggle"];
    "Mod+D".action.spawn = ["eww" "open" "--toggle" "dashboard"];
    "Mod+Shift+E".action.spawn = ["dms" "ipc" "call" "session" "toggle"];
    "Mod+Shift+C".action.spawn = "code";
    "Mod+Shift+R".action.spawn = ["sh" "-c" "thunar -q && thunar --daemon"];
    "Mod+Backspace".action.spawn = ["sh" "-c" "pkill -x wlogout || wlogout -b 4"];
    "Mod+Shift+S".action.spawn = "spotify";
    "Mod+Shift+P".action.spawn = "rofi-powermenu";
    "Mod+Shift+Y".action.spawn = "youtube-music";
    "Ctrl+Alt+Delete".action.spawn = ["ghostty" "-e" "btop"];
    "Mod+Ctrl+C".action.spawn = ["hyprpicker" "--autocopy" "--format=hex"];
    "Mod+F9".action.spawn = ["sh" "-c" "wlsunset -T 3800 -t 3799"];
    "Mod+F10".action.spawn = ["sh" "-c" "pkill -9 wlsunset || killall -9 wlsunset"];
    
    "Mod+Left".action.focus-column-left = [];
    "Mod+Right".action.focus-column-right = [];
    "Mod+H".action.focus-column-left = [];
    "Mod+L".action.focus-column-right = [];
    "Mod+S".action.spawn = ["sh" "-c" "niri msg action toggle-overview"];
    "Mod+Ctrl+Left".action.move-column-left = [];
    "Mod+Ctrl+Right".action.move-column-right = [];
    
    "Mod+K".action.focus-window-up = [];
    "Mod+J".action.focus-window-down = [];
    "Mod+Ctrl+K".action.move-column-to-workspace-up = [];
    "Mod+Ctrl+J".action.move-column-to-workspace-down = [];
    "Mod+WheelScrollDown".action.focus-workspace-down = [];
    "Mod+WheelScrollUp".action.focus-workspace-up = [];

    "Mod+R".action.switch-preset-column-width = [];
    "Mod+M".action.maximize-column = [];
    "Alt+Return".action.fullscreen-window = [];
    "Mod+W".action.toggle-window-floating = [];
    "Mod+1".action.focus-workspace = 1;
    "Mod+2".action.focus-workspace = 2;
    "Mod+3".action.focus-workspace = 3;
    "Mod+Shift+1".action.move-column-to-workspace = 1;
    "Mod+Shift+2".action.move-column-to-workspace = 2;
    "Mod+Shift+3".action.move-column-to-workspace = 3;
    "Mod+Shift+4".action.move-column-to-workspace = 4;
    "Mod+Shift+5".action.move-column-to-workspace = 5;

    "XF86AudioRaiseVolume".action.spawn = ["pamixer" "-i" "2"];
    "XF86AudioLowerVolume".action.spawn = ["pamixer" "-d" "2"];
    "XF86AudioMute".action.spawn = ["pamixer" "-t"];
    "XF86AudioMicMute".action.spawn = ["pamixer" "--default-source" "-t"];
    "XF86MonBrightnessUp".action.spawn = ["brightnessctl" "set" "+2%"];
    "XF86MonBrightnessDown".action.spawn = ["brightnessctl" "set" "2%-"];
    "XF86AudioPlay".action.spawn = ["playerctl" "play-pause"];
    "XF86AudioPause".action.spawn = ["playerctl" "play-pause"];
    "XF86AudioNext".action.spawn = ["playerctl" "next"];
    "XF86AudioPrev".action.spawn = ["playerctl" "previous"];
    "XF86Sleep".action.spawn = ["systemctl" "suspend"];
    "Mod+Up".action.focus-window-or-workspace-up = [];
    "Mod+Down".action.focus-window-or-workspace-down = [];
    "Mod+Ctrl+Up".action.move-workspace-up = [];
    "Mod+Ctrl+Down".action.move-workspace-down = [];
    "Mod+P".action.spawn = ["sh" "-c" "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -"];
    "Mod+Ctrl+P".action.spawn = ["sh" "-c" "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -"];
  };
}
