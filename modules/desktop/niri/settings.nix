# nirisettings.nix
{ pkgs, ... }: 

{
  programs.niri.settings = {
    # ==========================================
    # 🌍 ENVIRONMENT VARIABLES & SYSTEM SETTINGS
    # ==========================================
    prefer-no-csd = true;

    environment = {
      "XDG_CURRENT_DESKTOP" = "niri";
      "XDG_SESSION_DESKTOP" = "niri";
      "XDG_SESSION_TYPE" = "wayland";
      "GDK_BACKEND" = "wayland,x11,*";
      "NIXOS_OZONE_WL" = "1";
      "ELECTRON_OZONE_PLATFORM_HINT" = "wayland";
      "MOZ_ENABLE_WAYLAND" = "1";
      "OZONE_PLATFORM" = "wayland";
      "EGL_PLATFORM" = "wayland";
      "CLUTTER_BACKEND" = "wayland";
      "SDL_VIDEODRIVER" = "wayland";
      "QT_QPA_PLATFORM" = "wayland;xcb";
      "QT_WAYLAND_DISABLE_WINDOWDECORATION" = "1";
      "QT_QPA_PLATFORMTHEME" = "qt6ct";
      "QT_AUTO_SCREEN_SCALE_FACTOR" = "1";
      "QT_ENABLE_HIGHDPI_SCALING" = "1";
      "WLR_RENDERER_ALLOW_SOFTWARE" = "1";
      "NIXPKGS_ALLOW_UNFREE" = "1";
      "DMS_DISABLE_MATUGEN" = "1";
    };

    # ==========================================
    # 🚀 SPAWN ON STARTUP / AUTOSTART DAEMONS
    # ==========================================
    spawn = [
      # Standard desktop elements
      { command = [ "dms" "run" ]; }
      { command = [ "hyprsunset" "--temperature" "3000" ]; }
      
      # Clipboard history recording daemons
      { command = [ "wl-paste" "--type" "text" "--watch" "cliphist" "store" ]; }
      { command = [ "wl-paste" "--type" "image" "--watch" "cliphist" "store" ]; }
      
      # Clean up cliphist safely at start (replaces your Lua path verification block)
      { command = [ "sh" "-c" "rm -f \${XDG_CACHE_HOME:-$HOME/.cache}/cliphist/db" ]; }
    ];

    # ==========================================
    # ⌨️ HARDWARE INPUT & TOUCHPAD MANAGEMENT
    # ==========================================
    input = {
      keyboard = {
        xkb = {
          layout = "us,ru"; # Preserves your dual keyboard setup
          options = "caps:swapescape"; # Swaps Caps Lock and Escape
        };
        repeat-delay = 275;
        repeat-rate = 35;
        track-layout = "global";
      };

      touchpad = {
        natural-scroll = false;
        click-method = "clickfinger";
      };

      mouse = {
        accel-profile = "flat"; # Disables acceleration natively
        accel-speed = 0.0;
      };

      warp-mouse-to-focus = true;
      focus-follows-mouse.enable = true;
    };

    # ==========================================
    # 🖥️ DISPLAY OUTPUTS & PERSISTENT LAYOUT
    # ==========================================
    # Ported from your monitors.lua file mapping
    outputs."desc:BOE 0x0690" = {
      mode.width = 1920;  # Fallbacks to preferred native behavior
      mode.height = 1080;
      scale = 1.0;
      position.x = 0;
      position.y = 0;
    };

    # Niri utilizes 5 static workspace entries for visual bar tracking
    workspaces = {
      "1" = { open-on-output = "desc:BOE 0x0690"; };
      "2" = { open-on-output = "desc:BOE 0x0690"; };
      "3" = { open-on-output = "desc:BOE 0x0690"; };
      "4" = { open-on-output = "desc:BOE 0x0690"; };
      "5" = { open-on-output = "desc:BOE 0x0690"; };
    };

    # ==========================================
    # 📐 LAYOUT STYLE & WINDOW GAPS
    # ==========================================
    layout = {
      gaps = 9; # Matches your gaps_out setting
      center-focused-column = "never";

      # Border mappings from your Catppuccin styles
      border = {
        enable = true;
        width = 2;
        # Blends your pink/purple gradient hex arrays into native Niri hex strings
        active.color = "#ca9ee6";   
        inactive.color = "#b4befe"; 
      };

      # Sizing steps utilized by the "switch-preset-column-width" keybinding
      preset-column-widths = [
        { proportion = 1.0 / 3.0; }
        { proportion = 1.0 / 2.0; }
        { proportion = 2.0 / 3.0; }
      ];
    };

    # ==========================================
    # 🕹️ KEYBINDINGS & WORKFLOW CONTROLS
    # ==========================================
    binds = {
      # Applications and Core Launchers
      "Mod+Return".action.spawn = [ "ghostty" ]; # Triggers your default terminal
      "Mod+T".action.spawn = [ "ghostty" ];
      "Mod+A".action.spawn = [ "rofi" "-show" "drun" ]; # Strict syntax isolation for multi-args
      "Mod+Space".action.spawn = [ "rofi" "-show" "drun" ];
      "Mod+V".action.spawn = [ "rofi" "-show" "clipboard" ]; 
      "Mod+Z".action.spawn = [ "rofi" "-show" "emoji" ];

      # Session controls
      "Mod+Q".action.close-window = [ ];
      "Mod+Delete".action.quit = [ ];
      # Updated Keyboard Session Controls for DMS
      "Mod+Alt+L".action.spawn = [ "dms" "session" "lock" ];
      "Mod+N".action.spawn = [ "dms" "ipc" "call" "notifications" "toggle" ];
      "Mod+Shift+E".action.spawn = [ "dms" "ipc" "call" "session" "toggle" ];
      
      "Mod+Backspace".action.spawn = [ "sh" "-c" "pkill -x wlogout || wlogout -b 4" ];
      "Mod+Backspace".action.spawn = [ "sh" "-c" "pkill -x wlogout || wlogout -b 4" ];

      # Media & Quick Commands
      "Mod+Shift+S".action.spawn = [ "spotify" ];
      "Mod+Shift+Y".action.spawn = [ "youtube-music" ];
      "Ctrl+Alt+Delete".action.spawn = [ "ghostty" "-e" "btop" ];
      "Mod+Ctrl+C".action.spawn = [ "hyprpicker" "--autocopy" "--format=hex" ];

      # Night Mode Controls
      "Mod+F9".action.spawn = [ "hyprsunset" "--temperature" "3000" ];
      "Mod+F10".action.spawn = [ "sh" "-c" "pkill hyprsunset || pkill wlsunset" ];

      # Navigation Across Infinite Horizontal Ribbon (HJKL / Arrows)
      "Mod+Left".action.focus-column-left = [ ];
      "Mod+Right".action.focus-column-right = [ ];
      "Mod+H".action.focus-column-left = [ ];
      "Mod+L".action.focus-column-right = [ ];

      "Mod+Ctrl+Left".action.move-column-left = [ ];
      "Mod+Ctrl+Right".action.move-column-right = [ ];

      # Dynamic Workspace shifting (Up/Down Column Tracking)
      "Mod+Up".action.focus-workspace-up = [ ];
      "Mod+Down".action.focus-workspace-down = [ ];
      "Mod+K".action.focus-workspace-up = [ ];
      "Mod+J".action.focus-workspace-down = [ ];

      "Mod+Ctrl+Up".action.move-column-to-workspace-up = [ ];
      "Mod+Ctrl+Down".action.move-column-to-workspace-down = [ ];
      "Mod+Ctrl+K".action.move-column-to-workspace-up = [ ];
      "Mod+Ctrl+J".action.move-column-to-workspace-down = [ ];

      # Mouse Wheel Scroll Support for Stack Swaps
      "Mod+WheelScrollDown".action.focus-workspace-down = [ ];
      "Mod+WheelScrollUp".action.focus-workspace-up = [ ];

      # Window sizing manipulation
      "Mod+R".action.switch-preset-column-width = [ ];
      "Mod+F".action.maximize-column = [ ];
      "Alt+Return".action.fullscreen-window = [ ];
      "Mod+W".action.toggle-window-floating = [ ];

      # Discrete Absolute Index Workspaces Navigation 
      "Mod+1".action.focus-workspace = [ 1 ];
      "Mod+2".action.focus-workspace = [ 2 ];
      "Mod+3".action.focus-workspace = [ 3 ];
      "Mod+4".action.focus-workspace = [ 4 ];
      "Mod+5".action.focus-workspace = [ 5 ];

      "Mod+Shift+1".action.move-column-to-workspace = [ 1 ];
      "Mod+Shift+2".action.move-column-to-workspace = [ 2 ];
      "Mod+Shift+3".action.move-column-to-workspace = [ 3 ];
      "Mod+Shift+4".action.move-column-to-workspace = [ 4 ];
      "Mod+Shift+5".action.move-column-to-workspace = [ 5 ];

      # Hardware Controls
      "XF86AudioRaiseVolume".action.spawn = [ "pamixer" "-i" "2" ];
      "XF86AudioLowerVolume".action.spawn = [ "pamixer" "-d" "2" ];
      "XF86AudioMute".action.spawn = [ "pamixer" "-t" ];
      "XF86AudioMicMute".action.spawn = [ "pamixer" "--default-source" "-t" ];
      "XF86MonBrightnessUp".action.spawn = [ "brightnessctl" "set" "+2%" ];
      "XF86MonBrightnessDown".action.spawn = [ "brightnessctl" "set" "2%-" ];
      "XF86AudioPlay".action.spawn = [ "playerctl" "play-pause" ];
      "XF86AudioPause".action.spawn = [ "playerctl" "play-pause" ];
      "XF86AudioNext".action.spawn = [ "playerctl" "next" ];
      "XF86AudioPrev".action.spawn = [ "playerctl" "previous" ];
      "XF86Sleep".action.spawn = [ "systemctl" "suspend" ];

      # Screen Capture Scripts (Piped through grim + slurp directly)
      "Mod+P".action.spawn = [ "sh" "-c" "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -" ];
      "Mod+Ctrl+P".action.spawn = [ "sh" "-c" "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -" ];
    };

    # ==========================================
    # 🖼️ WINDOW RULES & WINDOW TRANSPARENCY
    # ==========================================
    window-rules = [
      # Web Browsers Layout Rules
      {
        matches = [
          { app-id = "^firefox$"; }
          { app-id = "^zen-"; }
          { app-id = "^floorp$"; }
          { app-id = "^brave-"; }
        ];
        opacity = 1.0;
      }
      # Floating layouts for tools, mixers, and configurations
      {
        matches = [
          { app-id = "^pavucontrol$"; }
          { app-id = "^blueman-manager$"; }
          { app-id = "^nm-applet$"; }
          { app-id = "^nm-connection-editor$"; }
          { app-id = "^nwg-look$"; }
          { app-id = "^qt5ct$"; }
          { app-id = "^qt6ct$"; }
          { app-id = "^yad$"; }
          { app-id = "^app.drey.Warp$"; }
          { app-id = "^net.davidotek.pupgui2$"; }
          { app-id = "^Signal$"; }
          { app-id = "^io.gitlab.theevilskeleton.Upscaler$"; }
          { app-id = "^eog$"; }
        ];
        open-floating = true;
      }
      # Development and System Utilities Opacity Controls
      {
        matches = [
          { app-id = "^kitty$"; }
          { app-id = "^Alacritty$"; }
          { app-id = "^org.wezfurlong.wezterm$"; }
          { app-id = "^nvim-wrapper$"; }
          { app-id = "^gnome-disks$"; }
          { app-id = "^org.gnome.Nautilus$"; }
          { app-id = "^thunar$"; }
          { app-id = "^pcmanfm$"; }
          { app-id = "^file-roller$"; }
          { app-id = "^VSCodium$"; }
          { app-id = "^code$"; }
          { app-id = "^steamwebhelper$"; }
          { app-id = "^Spotify$"; }
          { app-id = "^com.github.th_ch.youtube_music$"; }
        ];
        opacity = 0.80;
      }
      {
        matches = [
          { app-id = "^Emacs$"; }
          { app-id = "^obsidian$"; }
          { app-id = "^proton.vpn.app.gtk$"; }
          { app-id = "^heroic$"; }
          { app-id = "^lutris$"; }
          { app-id = "^discord$"; }
          { app-id = "^webcord$"; }
          { app-id = "^vesktop$"; }
        ];
        opacity = 0.90;
      }
      # Browser Picture-in-Picture window management
      {
        matches = [
          { title = "^Picture-in-Picture$"; }
        ];
        open-floating = true;
      }
    ];
  };
}