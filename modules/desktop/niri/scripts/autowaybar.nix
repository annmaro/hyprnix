{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "autowaybar";

  runtimeInputs = with pkgs; [
    coreutils
    hyprland       # provides hyprctl
    jq             # provides jq processing
    socat          # provides socket connectivity
    procps         # provides pgrep and pkill
    waybar         # ensures waybar can be called by the script
  ];

  text = ''
    # shellcheck disable=SC2016
    # shellcheck disable=SC2154
    
    # Store dynamic execution variables securely
    CURRENT_UID=\$(id -u)

    # Function to check if workspace is empty
    check_workspace_empty() {
        # Get active workspace ID
        active_workspace=\$(hyprctl activeworkspace -j | jq '.id')
        
        # Get all clients (windows) in the active workspace
        clients=\$(hyprctl clients -j | jq "[.[] | select(.workspace.id == \$active_workspace)]")
        
        # Return 0 if empty, 1 if windows present
        [ "\$(echo "\$clients" | jq 'length')" -eq 0 ]
    }

    # Function to show Waybar
    show_waybar() {
        if ! pgrep "waybar" > /dev/null; then
            waybar &
        fi
    }

    # Function to hide Waybar
    hide_waybar() {
        pkill waybar
    }

    # Main logic to toggle Waybar
    toggle_waybar() {
        if check_workspace_empty; then
            hide_waybar
        else
            show_waybar
        fi
    }

    # Initial check
    toggle_waybar

    # Listen to Hyprland events using NixOS socket path
    socat -U - UNIX-CONNECT:"/run/user/\$CURRENT_UID/hypr/\$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r event; do
        case "\$event" in
            workspace* | openwindow* | closewindow* | activewindow*)
                toggle_waybar
                ;;
        esac
    done
  '';
}