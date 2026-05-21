{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "window-name";

  # Nix securely maps these tools onto the script's local execution PATH at runtime
  runtimeInputs = with pkgs; [
    coreutils # Provides echo
    hyprland  # Provides hyprctl
    gnugrep   # Provides grep
    gawk      # Provides awk
  ];

  text = ''
    window_class=$(hyprctl activewindow | grep class | awk '{print $2}')
    
    case "$window_class" in
      kitty)
        echo "kitty "
        ;;
      firefox)
        echo "firefox "
        ;;
      *)
        echo "$window_class"
        ;;
    esac
  '';
}