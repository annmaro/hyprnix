{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "brightnesscontrol";

  runtimeInputs = with pkgs; [
    coreutils
    gnused
    gnugrep
    gawk
    brightnessctl  # provides hardware control over backlight
    libnotify      # provides notify-send
  ];

  text = ''
    # shellcheck disable=SC2006
    # shellcheck disable=SC2155
    # shellcheck disable=SC2001
    
    print_error() {
        cat << "EOF"
    ./brightnesscontrol.sh <action>
    ...valid actions are...
        i -- <i>ncrease brightness [+5%]
        d -- <d>ecrease brightness [-5%]
    EOF
    }

    send_notification() {
        # Using a modern awk construct instead of standard grep -P to ensure portability
        brightness=\$(brightnessctl info | awk '/Current brightness:/ {print \$4}' | tr -d '()%')
        brightinfo=\$(brightnessctl info | awk -F "'" '/Device/ {print \$2}')
        
        # Calculate stepped angle icon matches safely
        angle=\$(( ((brightness + 2) / 5) * 5 ))
        ico="\$HOME/.config/hypr/icons/notifications/vol/vol-\${angle}.svg"
        
        # Generate string progress bar
        bar=\$(seq -s "." \$((brightness / 15)) 2>/dev/null | sed 's/[0-9]//g' || echo "")
        
        notify-send -a "System" -r 91190 -t 800 -i "\${ico}" "\${brightness}\${bar}" "\${brightinfo}"
    }

    get_brightness() {
        brightnessctl -m | grep -o '[0-9]\+%' | head -c-2
    }

    case "\${1:-}" in
        i)  # increase the backlight by 5%
            brightnessctl set +5%
            send_notification 
            ;;
        d)  # decrease the backlight by 5% cleanly
            # Replaced bare '<' symbol syntax with standard bash integer bounds checking
            current_bright=\$(get_brightness)
            if [ "\$current_bright" -lt 5 ] ; then
                # avoid 0% brightness
                brightnessctl set 1%
            else
                # decrease the backlight by 5%
                brightnessctl set 5%-
            fi
            send_notification 
            ;;
        *)  # print error
            print_error
            ;;
    esac
  '';
}