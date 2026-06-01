{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "wallpaper";

  # Declare exact runtime dependencies needed for your wallpaper boot cycle
  runtimeInputs = with pkgs; [
    coreutils   # Provides 'sleep'
    procps      # Provides 'pgrep'
    awww        # Provides 'awww-daemon' [cite: 8]
    waypaper    # Provides 'waypaper' [cite: 12]
  ];

  text = ''
    # 1. Ensure the animation backend daemon is running in the background [cite: 6]
    if ! pgrep awww-daemon > /dev/null 2>&1; then
      awww-daemon &
      sleep 0.5
    fi

    # 2. Hand off the restoration job entirely to Waypaper [cite: 12]
    # This reads your setup inside ~/.config/waypaper/config.ini natively [cite: 4]
    waypaper --restore > /dev/null 2>&1
  '';
}