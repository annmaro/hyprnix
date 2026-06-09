{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "wallpaper";

  # Declare exact runtime dependencies needed for your wallpaper boot cycle
  runtimeInputs = with pkgs; [
    coreutils # Provides 'sleep'
    procps # Provides 'pgrep'
    awww # Provides 'awww-daemon'
    waypaper # Provides 'waypaper'
  ];

  text = ''
    # 1. Ensure the animation backend daemons are running in the background
    if ! pgrep -f "awww-daemon$" > /dev/null 2>&1; then
      awww-daemon &
    fi
    sleep 0.5

    # 2. Hand off the restoration job entirely to Waypaper 
    # This reads your setup inside ~/.config/waypaper/config.ini natively 
    waypaper --restore > /dev/null 2>&1
  '';
}
