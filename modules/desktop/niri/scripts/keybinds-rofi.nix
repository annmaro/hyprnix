{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "keybinds-show";
  
  # Dependencies are managed here. 
  # This puts these binaries in the PATH for this specific script.
  runtimeInputs = with pkgs;[ 
    procps 
    gnugrep 
    gnused 
    rofi 
    coreutils 
  ];

  text = ''
    # Kill yad to not interfere with these binds
    pkill yad || true

    # Check if rofi is already running
    if pidof rofi > /dev/null; then
      pkill rofi
    fi

    # Variables for configuration paths
    # Note: ''${} is used to escape the variable for bash within Nix
    keybinds_conf="''${XDG_CONFIG_HOME:-$HOME/.config}/hypr/binds.lua"
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-4/style-4.rasi"
    r_override="entry{placeholder:'Search KeyBinds...';}"
    msg='☣️ NOTE ☣️: Clicking with Mouse or Pressing ENTER will have NO function'

    # Match and grab bind lines
    keybinds=$(grep -E 'hl\.bind' "$keybinds_conf")

    if [[ -z "$keybinds" ]]; then
      echo "no keybinds found."
      exit 1
    fi

    # Cleanup: Strip out the Lua syntax to make it readable in Rofi
    display_keybinds=$(echo "$keybinds" | \
      sed -E "s/hl\.bind[em]?\(//g" | \
      sed "s/function()//g" | \
      sed "s/end)//g" | \
      sed "s/hl\.dsp\.//g" | \
      tr -d '"')

    # Fire up Rofi
    echo "$display_keybinds" | rofi -dmenu -i -theme-str "$r_override" -config "$rofi_theme" -mesg "$msg"
  '';
}