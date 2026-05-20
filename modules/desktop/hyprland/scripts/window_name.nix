{ pkgs }:

pkgs.writeShellApplication {
  name = "hyprland-window-icon";

  runtimeInputs = with pkgs; [
    coreutils
    hyprland       # provides hyprctl
    gnugrep        # provides grep
    gawk           # provides awk
  ];

  text = ''
    window_class=\$(hyprctl activewindow | grep class | awk '{print \$2}')
    
    case "\$window_class" in
      "kitty") echo "kitty " ;;
      "firefox") echo "firefox " ;;
      "discord") echo "discord " ;;
      "spotify") echo "" ;;
      "chromium-browser") echo "" ;;
      *) echo "\$window_class" ;;
    esac
  '';
}