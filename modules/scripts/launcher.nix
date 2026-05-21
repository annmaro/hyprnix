{
  pkgs,
  terminal,
  ...
}:
pkgs.writeShellApplication {
  name = "launcher";

  # Runtime dependencies that will be added to the script's PATH
  runtimeInputs = with pkgs; [
    rofi
    tmux
    procps    # Provides pidof and pkill
    coreutils # Provides cut, echo, etc.
  ];

  text = ''
    # check if rofi is already running
    if pidof rofi >/dev/null; then
      pkill rofi
      exit 0
    fi

    # Fallback to drun if no argument is provided
    action="''${1:-drun}"

    case "$action" in
    drun)
      rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-7/style-2.rasi"
      r_override="entry{placeholder:'Search Applications...';}listview{lines:9;}"

      rofi -show drun -theme-str "$r_override" -theme "$rofi_theme"
      ;;
    window)
      rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-4/style-4.rasi"
      r_override="entry{placeholder:'Search Windows...';}listview{lines:12;}"

      rofi -show window -theme-str "$r_override" -theme "$rofi_theme"
      ;;
    file)
      rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-2/style-2.rasi"
      r_override="entry{placeholder:'Search Files...';}listview{lines:8;}"

      rofi -show filebrowser -theme-str "$r_override" -theme "$rofi_theme"
      ;;
    tmux)
      rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-4/style-4.rasi"
      r_override="entry{placeholder:'Search Tmux Sessions...';}listview{lines:15;}"

      sessions=$(tmux sampled-session-placeholder-or-ls 2>/dev/null || tmux ls -F '#{session_name}: #{session_path} (#{session_windows} windows)' |
        rofi -dmenu -i -theme-str "$r_override" -theme "$rofi_theme" | cut -d: -f1)
      
      if [[ -n "$sessions" ]]; then
        # Note: ensuring $terminal variable from Nix is correctly interpolated
        ${terminal} --hold -e tmux attach -t "$sessions"
      fi
      ;;
    emoji)
      rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-4/style-4.rasi"
      r_override="entry{placeholder:'Search Emojis...';}listview{lines:15;}"

      rofi -modi emoji -show emoji -theme "''${rofi_theme}" -theme-str "$r_override"
      ;;
    games)
      r_override="entry{placeholder:'Search Games...';}listview{lines:15;}"
      rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-1/style-5.rasi"

      rofi -show games -modi games -theme "''${rofi_theme}" -theme-str "$r_override"
      ;;
    help | --help | -h)
      echo "Usage: launcher [ACTION]"
      echo "Launch various rofi modes with custom themes and settings."
      echo ""
      echo "Actions:"
      echo "  drun         Launch application search mode"
      echo "  window       Switch between open windows"
      echo "  file         Browse and search files"
      echo "  tmux         Search active tmux sessions"
      echo "  emoji        Search and insert emojis"
      echo "  games        Launch games menu"
      echo "  help         Display this help message"
      echo "  --help       Same as 'help'"
      echo ""
      echo "If no action is specified, defaults to 'drun' mode."
      exit 0
      ;;
    *)
      echo "Unknown action: $action" >&2
      exit 1
      ;;
    esac
  '';
}