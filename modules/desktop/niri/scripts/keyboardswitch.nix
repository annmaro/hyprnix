{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "keyboard-switch";

  # Nix will automatically place these packages into the script's PATH at runtime
  runtimeInputs = with pkgs; [ 
    coreutils 
    hyprland   # Provides 'hyprctl'
    jq         # Provides 'jq'
    gawk       # Provides 'awk'
    libnotify  # Provides 'notify-send'
  ];

  text = ''
    hyprctl switchxkblayout all next

    # We use jq safely to parse the active keymap
    layMain=$(hyprctl -j devices | jq -r '.keyboards[] | select(.main == true) | .active_keymap')

    # Send the desktop notification
    notify-send -a "System" -r 91190 -t 800 -i "$HOME/.config/hypr/icons/keyboard.svg" "$layMain"
  '';
}