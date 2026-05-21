{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "rofimusic";

  # Nix automatically registers these dependencies on the run-path of the script,
  # keeping our bash code clean, standard, and easy to maintain.
  runtimeInputs = with pkgs; [
    procps
    rofi
    libnotify
    mpv
  ];

  # Directives to bypass ShellCheck warnings inside the builder wrapper
  excludeShellChecks = [
    "SC2154" # Referenced but not assigned variables
    "SC2034" # Unused variables (safeguards dynamic associative arrays)
  ];

  text = ''
    if pidof rofi > /dev/null; then
      pkill rofi
      exit 0
    fi

    iDIR="$HOME/.config/hypr/icons"

    # We define the array using Bash hexadecimal escape codes.
    # This prevents the Nix builder from crashing on UTF-8 emoji strings.
    declare -A shuffle
    shuffle["Pop "$'\U1F4FB\U1F3B6']="https://youtube.com/playlist?list=PLMC9KNkIncKtPzgY-5rmhvj7fax8fdxoj"
    shuffle["Dance "$'\U1F4FB\U1F3B6']="https://dancewave.online:443/dance.mp3"
    shuffle["Lofi Radio "$'\u2615\U1F3B6']="https://play.streamafrica.net/lofiradio"
    shuffle["96.3 Easy Rock "$'\U1F4FB\U1F3B6']="https://radio-stations-philippines.com/easy-rock"
    shuffle["Rock "$'\U1F4FB\U1F3B6']="https://www.youtube.com/playlist?list=PL6Lt9p1lIRZ311J9ZHuzkR5A3xesae2pk"
    shuffle["Ghibli Music "$'\U1F3BB\U1F3B6']="https://youtube.com/playlist?list=PLNi74S754EXbrzw-IzVhpeAaMISNrzfUy&si=rqnXCZU5xoFhxfOl"
    shuffle["Top Youtube Music 2023 "$'\u2615\U1F3B6']="https://youtube.com/playlist?list=PLDIoUOhQQPlXr63I_vwF9GD8sAKh77dWU&si=y7qNeEVFNgA-XxKy"
    shuffle["Chillhop "$'\u2615\U1F3B6']="https://stream.zeno.fm/fyn8eh3h5f8uv"
    shuffle["SmoothChill "$'\u2615\U1F3B6']="https://media-ssl.musicradio.com/SmoothChill"
    shuffle["Smooth UK "$'\u2615\U1F3B6']="https://icecast.thisisdax.com/SmoothUKMP3"
    shuffle["Relaxing Music "$'\u2615\U1F3B6']="https://youtube.com/playlist?list=PLMIbmfP_9vb8BCxRoraJpoo4q1yMFg4CE"
    shuffle["Youtube Remix "$'\U1F4FB\U1F3B6']="https://youtube.com/playlist?list=PLeqTkIUlrZXlSNn3tcXAa-zbo95j0iN-0"
    shuffle["_Headbangers "$'\U1F3B5']="https://youtube.com/playlist?list=PLLosUj2DlL27g7BfUwAEoBr2Cr5EY0aP8"
    shuffle["_Motorway "$'\U1F3B5']="https://youtube.com/playlist?list=PLLosUj2DlL2613eXf-20WT6VQnZenrg0X"
    shuffle["_Carriageway "$'\U1F3B5']="https://youtube.com/playlist?list=PLLosUj2DlL26qNYOBo0_9yW9za1Egwp_y"
    shuffle["_Classics "$'\U1F3B5']="https://youtube.com/playlist?list=PLLosUj2DlL260MDLEfAej9CqFqdycTf3X"
    shuffle["_Metal "$'\U1F3B5']="https://youtube.com/playlist?list=PLLosUj2DlL246iFzN3q8-cYCA43YBxv_z"
    shuffle["_Limo "$'\U1F3B5']="https://youtube.com/playlist?list=PLLosUj2DlL27x3iZrv2ElvTK7-iQzQKYY"
    shuffle["_80s 90s 2000s "$'\U1F3B5']="https://youtube.com/playlist?list=PLLosUj2DlL24FAtYVcivVfHImRsu-ocj4"
    shuffle["_Hard Rock "$'\U1F3B5']="https://youtube.com/playlist?list=PLLosUj2DlL25A5u32lnZXtc_AUy-u2AUd"

    declare -A menu_options
    for key in "''${!shuffle[@]}"; do 
      menu_options["$key"]="''${shuffle[$key]}"
    done

    notification() {
      notify-send -e -t 2500 -u normal -i "$iDIR/music.png" "Playing now: $1"
    }

    main() {
      r_override="entry{placeholder:'Search Music...';}listview{lines:10;}"
      choice=$(printf "%s\n" "''${!menu_options[@]}" | rofi -dmenu -theme-str "$r_override" -theme ~/.config/rofi/launchers/type-2/style-2.rasi -i -p "")

      if [ -z "$choice" ]; then
        exit 1
      fi

      link="''${menu_options[$choice]}"

      notification "$choice"

      if [[ "$link" == *playlist* ]]; then
        mpv --vid=no --shuffle "$link"
      else
        mpv "$link"
      fi
    }

    pkill mpv && notify-send -e -t 2500 -u low -i "$iDIR/music.png" "Playback stopped" || main
  '';
}