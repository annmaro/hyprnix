{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "niri-keybinds-viewer";

  runtimeInputs = with pkgs; [
    coreutils
    procps    # Provides 'pidof' and 'pkill'
    gawk      # Provides 'awk'
    yad       # Provides 'yad' graphical dialogs
  ];

  text = ''
    # Kill existing instances to prevent duplicates
    if pidof rofi >/dev/null; then pkill rofi; fi
    if pidof yad >/dev/null; then pkill yad; fi

    # Safely parse settings out of your separated Niri configuration
    get_nix_value() {
        awk '
        /binds = {/ {inside_binds=1; next} 
        inside_binds && /};/ {inside_binds=0} 
        inside_binds && $0 ~ key {print gensub(/.*\[ "([^"]+)".*/, "\\1", "g", $0)}
        ' key="$1" "${./nirisettings.nix}"  # <--- Nix inserts the exact safe file path here
    }

    _terminal=$(get_nix_value "Mod\\+Return")
    _launcher=$(get_nix_value "Mod\\+A")

    # Render the interactive Niri keybind cheat sheet table
    yad \
      --center \
      --title="Niri Tiling Keybinds" \
      --no-buttons \
      --list \
      --width=760 \
      --height=920 \
      --column="Key:" \
      --column="Description:" \
      --column="Niri Action / Command:" \
      --timeout-indicator=bottom \
      "SUPER Return" "Launch terminal" "$_terminal" \
      "SUPER T" "Launch terminal" "$_terminal" \
      "SUPER A" "Launch application menu" "rofi -show drun" \
      "SUPER SPACE" "Launch application menu" "rofi -show drun" \
      "SUPER V" "Clipboard manager" "rofi -show clipboard" \
      "SUPER Z" "Launch emoji picker" "rofi -show emoji" \
      "SUPER SHIFT S" "Launch Spotify" "spotify" \
      "SUPER SHIFT Y" "Launch YouTube Music" "youtube-music" \
      "CTRL ALT Delete" "Open system monitor" "$_terminal -e btop" \
      "SUPER CTRL C" "Colour picker" "hyprpicker --autocopy --format=hex" \
      \
      "SUPER F9" "Enable night mode (Warm)" "hyprsunset --temperature 3000" \
      "SUPER F10" "Disable night mode" "pkill hyprsunset" \
      \
      "SUPER Q" "Close active window" "close-window" \
      "SUPER Delete" "Quit Niri Session" "quit" \
      "SUPER ALT L" "Lock screen" "hyprlock" \
      "SUPER Backspace" "Power menu" "wlogout -b 4" \
      \
      "SUPER ← / H" "Focus column left" "focus-column-left" \
      "SUPER → / L" "Focus column right" "focus-column-right" \
      "SUPER Ctrl ←" "Move window column left" "move-column-left" \
      "SUPER Ctrl →" "Move window column right" "move-column-right" \
      \
      "SUPER ↑ / K" "Focus workspace up" "focus-workspace-up" \
      "SUPER ↓ / J" "Focus workspace down" "focus-workspace-down" \
      "SUPER Ctrl ↑ / K" "Move column to workspace up" "move-column-to-workspace-up" \
      "SUPER Ctrl ↓ / J" "Move column to workspace down" "move-column-to-workspace-down" \
      "SUPER Mouse Scroll" "Scroll up/down workspaces" "focus-workspace-up / down" \
      \
      "SUPER R" "Cycle window width steps" "switch-preset-column-width" \
      "SUPER F" "Maximize window column" "maximize-column" \
      "ALT Return" "Toggle absolute fullscreen" "fullscreen-window" \
      "SUPER W" "Toggle window floating" "toggle-window-floating" \
      \
      "XF86MonBrightnessDown" "Decrease brightness" "brightnessctl set 2%-" \
      "XF86MonBrightnessUp" "Increase brightness" "brightnessctl set +2%" \
      "XF86AudioLowerVolume" "Lower volume" "pamixer -d 2" \
      "XF86AudioRaiseVolume" "Increase volume" "pamixer -i 2" \
      "XF86AudioMicMute" "Mute microphone" "pamixer --default-source -t" \
      "XF86AudioMute" "Mute audio" "pamixer -t" \
      "XF86AudioPlay" "Play/Pause media" "playerctl play-pause" \
      "XF86AudioNext" "Next media track" "playerctl next" \
      "XF86AudioPrev" "Previous media track" "playerctl previous" \
      "XF86Sleep" "Put system to sleep" "systemctl suspend" \
      \
      "SUPER P" "Screenshot region to swappy" "grim + slurp -> swappy" \
      "SUPER CTRL P" "Screenshot region to swappy" "grim + slurp -> swappy" \
      \
      "SUPER 1-5" "Jump to absolute workspace index" "focus-workspace [1-5]" \
      "SUPER SHIFT 1-5" "Move column to absolute workspace index" "move-column-to-workspace [1-5]"
  '';
}