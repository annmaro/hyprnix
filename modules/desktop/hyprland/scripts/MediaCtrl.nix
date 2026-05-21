{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "mediacontrol";

  runtimeInputs = with pkgs; [
    coreutils
    playerctl
    libnotify # provides notify-send
  ];

  text = ''
    ## /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
    # Playerctl

    music_icon="\${XDG_CONFIG_HOME:-\$HOME/.config}/hypr/icons/music.png"

    # Play the next track
    play_next() {
        playerctl next
        show_music_notification
    }

    # Play the previous track
    play_previous() {
        playerctl previous
        show_music_notification
    }

    # Toggle play/pause
    toggle_play_pause() {
        playerctl play-pause
        show_music_notification
    }

    # Stop playback
    stop_playback() {
        playerctl stop
        notify-send -e -u low -i "\$music_icon" "Playback Stopped"
    }

    # Display notification with song information
    show_music_notification() {
        status=\$(playerctl status 2>/dev/null || echo "Stopped")
        if [[ "\$status" == "Playing" ]]; then
            song_title=\$(playerctl metadata title 2>/dev/null || echo "Unknown Title")
            song_artist=\$(playerctl metadata artist 2>/dev/null || echo "Unknown Artist")
            notify-send -e -u low -i "\$music_icon" "Now Playing:" "\$song_title by \$song_artist"
        elif [[ "\$status" == "Paused" ]]; then
            notify-send -e -u low -i "\$music_icon" "Playback Paused"
        fi
    }

    # Get media control action from command line argument
    case "\$1" in
        "next")
            play_next
            ;;
        "previous")
            play_previous
            ;;
        "play-pause")
            toggle_play_pause
            ;;
        "stop")
            stop_playback
            ;;
        *)
            echo "Usage: \$0 [next|previous|play-pause|stop]"
            exit 1
            ;;
    esac
  '';
}