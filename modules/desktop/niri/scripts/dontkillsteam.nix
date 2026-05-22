{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "smart-kill";

  runtimeInputs = with pkgs; [
    hyprland   # Provides hyprctl
    jq         # Provides jq for JSON parsing
    xdotool    # Provides xdotool for window manipulation
  ];

  text = ''
    if [[ $(hyprctl activewindow -j | jq -r ".class") == "Steam" ]]; then
        xdotool windowunmap "$(xdotool getactivewindow)"
    else
        hyprctl dispatch killactive ""
    fi
  '';
}
