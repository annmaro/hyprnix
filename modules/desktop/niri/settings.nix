# settings.nix
{ pkgs, config, ... }: 

{
  # ==========================================
  # 🌍 ENVIRONMENT VARIABLES & SYSTEM SETTINGS
  # ==========================================
  prefer-no-csd = true;
  hotkey-overlay.skip-at-startup = true;
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
    "WLR_RENDERER_ALLOW_SOFTWARE" = "1";
    "NIXPKGS_ALLOW_UNFREE" = "1";
    "DMS_DISABLE_MATUGEN" = "1";
  };

  # ==========================================
  # 🚀 SPAWN ON STARTUP / AUTOSTART DAEMONS
  # ==========================================
  spawn-at-startup = [
    { command = [ "wlsunset" "-l" "23.3" "-L" "85.3" "-T" "6500" "-t" "3000" ]; }
  ];

  # ==========================================
  # ⌨️ HARDWARE INPUT & TOUCHPAD MANAGEMENT
  # ==========================================
  input = {
    keyboard = {
      xkb = {
        layout = "us,in";
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
      accel-profile = "flat";
      accel-speed = 0.0;
    };
    warp-mouse-to-focus.enable = true; 
    focus-follows-mouse.enable = true;
  };

  # ==========================================
  # 🖥️ DISPLAY OUTPUTS & PERSISTENT LAYOUT
  # ==========================================
  outputs."desc:BOE 0x0690" = {
    mode.width = 1920;
    mode.height = 1080;
    scale = 1.0;
    position.x = 0; 
    position.y = 0; 
  };

  workspaces = {
    "1" = { open-on-output = "desc:BOE 0x0690"; };
    "2" = { open-on-output = "desc:BOE 0x0690"; };
    "3" = { open-on-output = "desc:BOE 0x0690"; };
    "4" = { open-on-output = "desc:BOE 0x0690"; };
    "5" = { open-on-output = "desc:BOE 0x0690"; }; 
  };

  # ==========================================
  # 📐 LAYOUT STYLE, WINDOW GAPS, & BLUR
  # ==========================================
  layout = {
    gaps = 9;
    center-focused-column = "never";
    border = {
      enable = true;
      width = 2;
      active.color = "#ca9ee6";
      inactive.color = "#b4befe"; 
    };
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
    "Mod+Return".action.spawn = [ "ghostty" ];
    "Mod+T".action.spawn = [ "ghostty" ];
    "Mod+C".action.spawn = [ "editor" ];
    "Mod+F".action.spawn = [ "browser" ];
    "Mod+A".action.spawn = [ "rofi" "-show" "drun" ];
    "Mod+Space".action.spawn = [ "rofi" "-show" "drun" ];
    "Mod+V".action.spawn = [ "rofi" "-show" "clipboard" ];
    "Mod+Z".action.spawn = [ "rofi" "-show" "emoji" ];
    "Mod+G".action.spawn = [ "launcher" "games" ];
    "Mod+Alt+G".action.spawn = [ "gamemode" ];
    
    "Mod+Q".action.close-window = [ ];
    "Mod+Delete".action.quit = [ ];
    "Mod+Alt+L".action.spawn = [ "dms" "session" "lock" ];
    "Mod+N".action.spawn = [ "dms" "ipc" "call" "notifications" "toggle" ];
    "Mod+Shift+E".action.spawn = [ "dms" "ipc" "call" "session" "toggle" ];
    "Mod+Backspace".action.spawn = [ "sh" "-c" "pkill -x wlogout || wlogout -b 4" ];
    "Mod+Shift+S".action.spawn = [ "spotify" ];
    "Mod+Shift+Y".action.spawn = [ "youtube-music" ];
    "Ctrl+Alt+Delete".action.spawn = [ "ghostty" "-e" "btop" ];
    "Mod+Ctrl+C".action.spawn = [ "hyprpicker" "--autocopy" "--format=hex" ];
    
    "Mod+F9".action.spawn = [ "wlsunset" "-l" "23.3" "-L" "85.3" "-T" "6500" "-t" "3000" ];
    "Mod+F10".action.spawn = [ "pkill" "wlsunset" ];
    
    "Mod+Left".action.focus-column-left = [ ];
    "Mod+Right".action.focus-column-right = [ ];
    "Mod+H".action.focus-column-left = [ ];
    "Mod+L".action.focus-column-right = [ ];
    "Mod+S".action.toggle-overview = [ ];
    "Mod+Ctrl+Left".action.move-column-left = [ ];
    "Mod+Ctrl+Right".action.move-column-right = [ ];
    
       
    "Mod+K".action.focus-window-up = [ ];
    "Mod+J".action.focus-window-down = [ ];
    "Mod+Ctrl+K".action.move-column-to-workspace-up = [ ];
    "Mod+Ctrl+J".action.move-column-to-workspace-down = [ ];

    "Mod+WheelScrollDown".action.focus-workspace-down = [ ];
    "Mod+WheelScrollUp".action.focus-workspace-up = [ ];

    "Mod+R".action.switch-preset-column-width = [ ];
    "Alt+Return".action.fullscreen-window = [ ];
    "Mod+W".action.toggle-window-floating = [ ];
    
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
    "Mod+Up".action.focus-window-or-workspace-up = [ ];
    "Mod+Down".action.focus-window-or-workspace-down = [ ];
    "Mod+Ctrl+Up".action.move-workspace-up = [ ];
    "Mod+Ctrl+Down".action.move-workspace-down = [ ];
    "Mod+P".action.spawn = [ "sh" "-c" "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -" ];
    "Mod+Ctrl+P".action.spawn = [ "sh" "-c" "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -" ];
  };

  # ==========================================
  # 🖼️ WINDOW RULES, TRANSPARENCY & BLUR FILTERS
  # ==========================================
  window-rules = [
    {
      matches = [
        { app-id = "^firefox$"; }
        { app-id = "^zen-"; }
        { app-id = "^floorp$"; }
        { app-id = "^brave-"; }
        { app-id = "^vlc$"; }
        { app-id = "^easyeffects$"; }
        { app-id = "^gapless$"; }
      ];
      opacity = 1.0;
    }
    {
      matches = [
        { app-id = "^kitty$"; }
        { app-id = "^com.mitchellh.ghostty$"; }
        { app-id = "^Alacritty$"; }
        { app-id = "^org.wezfurlong.wezterm$"; }
        { app-id = "^nvim-wrapper$"; }
        { app-id = "^VSCodium$"; }
        { app-id = "^code$"; }
      ];
      opacity = 0.94;
    }
    {
      matches = [
        { app-id = "^gnome-disks$"; }
        { app-id = "^org.gnome.Nautilus$"; }
        { app-id = "^thunar$"; }
        { app-id = "^pcmanfm$"; }
        { app-id = "^file-roller$"; }
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
    {
      matches = [ { title = "^Picture-in-Picture$"; } ];
      open-floating = true;
    }
  ];
}