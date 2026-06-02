{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "wallpaper";

  # Declare exact runtime dependencies needed for your wallpaper boot cycle
  runtimeInputs = with pkgs; [
    coreutils # Provides 'sleep'
    procps # Provides 'pgrep'
    awww # Provides 'awww-daemon'
    waypaper # Provides 'waypaper'
    imagemagick # Provides 'magick' for blurring
    gnugrep # Provides 'grep'
    gnused # Provides 'sed'
  ];

  text = ''
    # 1. Ensure the animation backend daemon is running in the background 
    if ! pgrep awww-daemon > /dev/null 2>&1; then
      awww-daemon &
      sleep 0.5
    fi

    # 2. Hand off the restoration job entirely to Waypaper 
    # This reads your setup inside ~/.config/waypaper/config.ini natively 
    waypaper --restore > /dev/null 2>&1

    # 3. Generate and set a blurred overview wallpaper for Niri
    CONFIG_FILE="$HOME/.config/waypaper/config.ini"
    if [ -f "$CONFIG_FILE" ]; then
      # Extract the wallpaper path from the config and expand ~ to $HOME
      WALLPAPER=$(grep -m 1 '^wallpaper =' "$CONFIG_FILE" | cut -d '=' -f 2- | sed 's/^[[:space:]]*//' | sed "s|^~|$HOME|")
      
      if [ -n "$WALLPAPER" ] && [ -f "$WALLPAPER" ]; then
        BLURRED="/tmp/niri-overview-blurred.jpg"
        magick "$WALLPAPER" -blur 0x25 "$BLURRED"
        awww img -n overlay "$BLURRED"
      fi
    fi
  '';
}
