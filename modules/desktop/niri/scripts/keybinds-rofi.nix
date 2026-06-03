{ pkgs, ... }:

pkgs.writeShellScriptBin "rofi-keybinds" ''
  # Target the active home-manager deployment path for this file
  NIRI_CONFIG="$HOME/.config/niri/config.kdl"

  if [ ! -f "$NIRI_CONFIG" ]; then
      echo "Error: Niri config not found at $NIRI_CONFIG" | ${pkgs.rofi}/bin/rofi -dmenu -p "⚠️ Error"
      exit 1
  fi

  # 1. Grab everything between 'binds {' and the matching '}'
  # 2. Filter out comments, empty lines, and brackets
  # 3. Clean up syntax to look like "Keybind  ->  Action"
  awk '/binds \{/{flag=1; next} /\}/{if(flag) exit} flag' "$NIRI_CONFIG" | \
  grep -v -E '^[[:space:]]*(\/\/|#|$)' | \
  sed -E 's/^[[:space:]]*"([^"]+)"[[:space:]]*\{[[:space:]]*(spawn|close-window|quit|fullscreen-window|maximize-column|toggle-window-floating|switch-preset-column-width|focus|move)[[:space:]]*([^;]*);?[[:space:]]*\}/\1  ->  \2 \3/g' | \
  sed -E 's/[";]//g' | \
  sed -E 's/[{}]//g' | \
  sed -E 's/[[:space:]]+==>[[:space:]]+/  ->  /g' | \
  ${pkgs.rofi}/bin/rofi -dmenu -i -p "⌨️ Dynamic Keybindings" \
      -theme-str 'window { width: 45%; height: 50%; }' \
      -theme-str 'listview { lines: 20; }'
''
