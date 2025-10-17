{ host, pkgs, ... }:
let
  inherit (import ../../../../../hosts/${host}/variables.nix) clock24h;
  
in
{
  
  home-manager.sharedModules = [
    (_: {
      programs.waybar = {
        enable = true;
        systemd = {
          enable = false;
          target = "graphical-session.target";
        };
        settings = [
          {
            layer = "top";
            position = "top";
            mode = "dock"; # Fixes fullscreen issues
            height = 35; # 35
            exclusive = true;
            passthrough = false;
            gtk-layer-shell = false;
            ipc = true;
            fixed-center = true;
            margin-top = 10;
            margin-left = 10;
            margin-right = 10;
            margin-bottom = 0;

            modules-left = [
               "custom/icon"
               "cpu"
               "memory"
               "custom/gpuinfo" 
               "temperature"
               "custom/window-name"
            ];
            # modules-center = ["clock" "custom/notification"];
            modules-center = [
              "hyprland/workspaces"
              "mpris"
            ];
            modules-right = [
              "custom/weather"
              "battery"
              "backlight"
              "pulseaudio"
              "network"
              "tray"
              "clock"
              "custom/notification"
              "custom/power"
            ];

            "custom/notification" = {
              tooltip = false;
              format = "{icon}";
              format-icons = {
                notification = "<span foreground='red'><sup></sup></span>";
                none = "";
                dnd-notification = "<span foreground='red'><sup></sup></span>";
                dnd-none = "";
                inhibited-notification = "<span foreground='red'><sup></sup></span>";
                inhibited-none = "";
                dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
                dnd-inhibited-none = "";
              };
              return-type = "json";
              exec-if = "which swaync-client";
              exec = "swaync-client -swb";
              on-click = "swaync-client -t -sw";
              on-click-right = "swaync-client -d -sw";
              escape = true;
            };

            "custom/colour-temperature" = {
              format = "{} ";
              exec = "wl-gammarelay-rs watch {t}";
              on-scroll-up = "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n +100";
              on-scroll-down = "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n -100";
            };
            "custom/cava_mviz" = {
              exec = "${../../scripts/WaybarCava.sh}";
              format = "{}";
            };
            "cava" = {
              hide_on_silence = false;
              framerate = 60;
              bars = 10;
              format-icons = [
                "▁"
                "▂"
                "▃"
                "▄"
                "▅"
                "▆"
                "▇"
                "█"
              ];
              input_delay = 1;
              # "noise_reduction" = 0.77;
              sleep_timer = 5;
              bar_delimiter = 0;
              on-click = "playerctl play-pause";
            };
            "custom/gpuinfo" = {
              exec = "${../../scripts/gpuinfo.sh}";
              return-type = "json";
              format = "{0}";
              on-click = "${../../scripts/gpuinfo.sh} --toggle";
              interval = 5; # once every 5 seconds
              tooltip = true;
              max-length = 1000;
            };
            "custom/icon" = {
              format = " ";
             # exec = "echo ' '";
             # format = "{}";
            };
            "mpris" = {
              format = "{player_icon} {title} - {artist}";
              format-paused = "{status_icon} <i>{title} - {artist}</i>";
              player-icons = {
                default = "▶";
                spotify = "";
                quodlibet = "𝆺𝅥𝅮";
                mpv = "󰐹";
                vlc = "󰕼";
                firefox = "";
                chromium = "";
                kdeconnect = "";
                mopidy = "";
              };
              status-icons = {
                paused = "⏸";
                playing = "";
              };
              ignored-players = [
                "firefox"
                "chromium"
              ];
              max-length = 30;
            };
            "temperature" = {
              hwmon-path = "/sys/class/hwmon/hwmon4/temp1_input";
              critical-threshold = 88;
              format = "{icon} {temperatureC}°C";
              format-icons = [
                ""
                ""
                ""
              ];
              interval = 10;
            };
            "hyprland/language" = {
              format = "{short}"; # can use {short} and {variant}
              on-click = "${../../scripts/keyboardswitch.sh}";
            };
            "hyprland/workspaces" = {
              disable-scroll = true;
              all-outputs = true;
              active-only = false;
              on-click = "activate";
              format = "{icon}";
              format-icons = {
               "1" = "";
               "2" = "";
               "3" = "";
               "4" = "";
               "5" = "";
              urgent = "";
              active = "";  
              default = "";
              sort-by-number = true;
              };
              persistent-workspaces = {
                "1" = [ ];
                "2" = [ ];
                "3" = [ ];
                "4" = [ ];
                "5" = [ ];
              };
            };

            "hyprland/window" = {
              format = "  {}";
              separate-outputs = true;
              rewrite = {
                "harvey@hyprland =(.*)" = "$1 ";
                "(.*) — Mozilla Firefox" = "$1 󰈹";
                "(.*)Mozilla Firefox" = " Firefox 󰈹";
                "(.*) - Visual Studio Code" = "$1 󰨞";
                "(.*)Visual Studio Code" = "Code 󰨞";
                "(.*) — Dolphin" = "$1 󰉋";
                "(.*)Spotify" = "Spotify 󰓇";
                "(.*)Spotify Premium" = "Spotify 󰓇";
                "(.*)Steam" = "Steam 󰓓";
              };
              max-length = 1000;
            };

            "idle_inhibitor" = {
              format = "{icon}";
              format-icons = {
                activated = "󰥔";
                deactivated = "";
              };
            };

            "clock" = {
              format = if clock24h == true then "{:%a %d %b %R}" else "{:%a %d %b %I:%M %p}";
              format-alt = if clock24h == true then "{:%a %d %b %I:%M %p}" else "{:%a %d %b %R}";
              # format = "{:%a %d %b %R}";
              # format = "{:%R 󰃭 %d·%m·%y}"; # Inverted
              # format-alt = "{:%I:%M %p}";
              tooltip-format = "<tt><big>{calendar}</big></tt>";
              calendar = {
                mode = "month";
                mode-mon-col = 3;
                on-scroll = 1;
                on-click-right = "mode";
                format = {
                  months = "<span color='#ffead3'><b>{}</b></span>";
                  weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                  today = "<span color='#ff6699'><b>{}</b></span>";
                };
              };
              actions = {
                on-click-right = "mode";
                on-click-forward = "tz_up";
                on-click-backward = "tz_down";
                on-scroll-up = "shift_up";
                on-scroll-down = "shift_down";
              };
            };

            "cpu" = {
              interval = 10;
              format = "󰍛 {usage}%";
              format-alt = "{icon0}{icon1}{icon2}{icon3}";
              format-icons = [
                "▁"
                "▂"
                "▃"
                "▄"
                "▅"
                "▆"
                "▇"
                "█"
              ];
            };

            "memory" = {
              interval = 30;
              format = "󰾆 {percentage}%";
              format-alt = "󰾅 {used}GB";
              max-length = 10;
              tooltip = true;
              tooltip-format = " {used:.1f}GB/{total:.1f}GB";
            };
           
            "custom/weather" = {
             exec = "${../../scripts/weather.sh}";
             restart-interval = 600;
             return-type = "json";
             }; 
            "backlight" = {
              format = "{icon} {percent}%";
              format-icons = [
                ""
                ""
                ""
                ""
                ""
                ""
                ""
                ""
                ""
              ];
              on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 2%+";
              on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 2%-";
            };

            "network" = {
              on-click = "nm-connection-editor";
              # "interface" = "wlp2*"; # (Optional) To force the use of this interface
              #format-wifi = "󰤨 Wi-Fi";
              # format-wifi = " {bandwidthDownBits}  {bandwidthUpBits}";
              format-wifi = "  {essid}";
              format-ethernet = "󱘖 Wired";
              # format-ethernet = " {bandwidthDownBits}  {bandwidthUpBits}";
              #format-linked = "󰤪 Secure";
              format-linked = "󱘖 {ifname} (No IP)";
              #format-disconnected = "󰤮 Off";
              format-disconnected = "󰤮 Disconnected";
              format-alt = "󰤨 {signalStrength}%";
              tooltip-format = "󱘖 {ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
              interval = 5;
            };

            "bluetooth" = {
              format = "";
              # format-disabled = ""; # an empty format will hide the module
              format-connected = " {num_connections}";
              tooltip-format = " {device_alias}";
              tooltip-format-connected = "{device_enumerate}";
              tooltip-format-enumerate-connected = " {device_alias}";
              on-click = "blueman-manager";
            };

            "pulseaudio" = {
              format = "{icon} {volume}";
              format-muted = " ";
              on-click = "pavucontrol -t 3";
              tooltip-format = "{icon} {desc} // {volume}%";
              scroll-step = 4;
              format-icons = {
                headphone = "";
                hands-free = "";
                headset = "";
                phone = "";
                portable = "";
                car = "";
                default = [
                  ""
                  ""
                  ""
                ];
              };
            };

            "pulseaudio#microphone" = {
              format = "{format_source}";
              format-source = " {volume}%";
              format-source-muted = "";
              on-click = "pavucontrol -t 4";
              tooltip-format = "{format_source} {source_desc} // {source_volume}%";
              scroll-step = 5;
            };

            "tray" = {
              icon-size = 12;
              spacing = 5;
            };

            "battery" = {
              states = {
                good = 95;
                warning = 30;
                critical = 20;
              };
              format = "{icon} {capacity}%";
              # format-charging = " {capacity}%";
              format-charging = " {capacity}%";
              format-plugged = " {capacity}%";
              format-alt = "{time} {icon}";
              format-icons = [
                "󰂎"
                "󰁺"
                "󰁻"
                "󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
            };

            "custom/window-name" = {
              format = "<b>{}</b>";
              interval = 1;
              exec = "${../../scripts/window_name.sh}";
            };

            "custom/power" = {
              format = "{}";
              on-click = "wlogout -b 4";
              interval = 86400; # once every day
              tooltip = true;
            };
          }
        ];
        style = ''
          * {
            font-family: "monospace";
            font-size: 14px;
            margin: 0px;
            padding: 0px;
          }

          @define-color base   #1e1e2e;
          @define-color mantle #181825;
          @define-color crust  #11111b;

          @define-color text     #cdd6f4;
          @define-color subtext0 #a6adc8;
          @define-color subtext1 #bac2de;

          @define-color surface0 #313244;
          @define-color surface1 #45475a;
          @define-color surface2 #585b70;

          @define-color overlay0 #6c7086;
          @define-color overlay1 #7f849c;
          @define-color overlay2 #9399b2;

          @define-color blue      #89b4fa;
          @define-color lavender  #b4befe;
          @define-color sapphire  #74c7ec;
          @define-color sky       #89dceb;
          @define-color teal      #94e2d5;
          @define-color green     #a6e3a1;
          @define-color yellow    #f9e2af;
          @define-color peach     #fab387;
          @define-color maroon    #eba0ac;
          @define-color red       #f38ba8;
          @define-color mauve     #cba6f7;
          @define-color pink      #f5c2e7;
          @define-color flamingo  #f2cdcd;
          @define-color rosewater #f5e0dc;

          window#waybar {
            transition-property: background-color;
            transition-duration: 0.5s;
            background: transparent;
            /*border: 2px solid @overlay0;*/
            /*background: @theme_base_color;*/
            border-radius: 10px;
          }

          window#waybar.hidden {
            opacity: 0.2;
          }

          tooltip {
            background: #1e1e2e;
            border-radius: 8px;
          }

          tooltip label {
            color: #cad3f5;
            margin-right: 5px;
            margin-left: 5px;
          }

          /* This section can be use if you want to separate waybar modules */
          .modules-left {
          	background: @theme_base_color;
            border-radius: 8px;
            padding-right: 15px;
            padding-left: 15px;
          }
          .modules-center {
          	background: @theme_base_color;
            border-radius: 8px;
            padding-right: 15px;
            padding-left: 15px;
          }
          .modules-right {
          	background: @theme_base_color;
           	border-radius: 8px;
            padding-right: 15px;
            padding-left: 15px;
          }

          #idle_inhibitor {
            color: @blue;
            padding-left: 5px;
            padding-right: 5px;
          }

          #bluetooth {
            color: @blue;
            font-size: 15px;
            padding-left: 5px;
            padding-right: 5px;
          }

          #backlight {
            color: @blue;
            font-size: 15px;
             padding-left: 5px;
             padding-right: 5px;
          }

          #battery {
            font-size: 15px;
            color: #a6da95;
            padding-left: 5px;
            padding-right: 5px;
          }

          @keyframes blink {
            to {
              color: @surface0;
            }
          }

          #battery.critical:not(.charging) {
            background-color: @red;
            color: @theme_text_color;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
            box-shadow: inset 0 -3px transparent;
          }

          #custom-updates {
            color: @blue
          }

          #custom-notification {
            color: #dfdfdf;
            padding: 0px 5px;
            border-radius: 5px;
          }

          #language {
            color: @blue
          }

          #clock {
            color: @yellow;
            font-size: 15px;
            padding-left: 5px;
            padding-right: 5px;
          }

          #custom-icon {
            font-size: 20px;
            padding-left: 2px;
            padding-right: 5px;
            color: #cba6f7;
          }

          #custom-gpuinfo {
            color: @maroon;
            font-size: 15px;
            padding-left: 5px;
            padding-right: 5px;
          }

          #cpu {
            color: @yellow;
            font-size: 15px;
            padding-left: 5px;
            padding-right: 5px;
          }

          #custom-keyboard,
          #memory {
            color: @green;
            font-size: 15px;
            padding-left: 5px;
            padding-right: 5px;
          }

          #disk {
            color: @sapphire;
            font-size: 15px;
            padding-left: 5px;
            padding-right: 5px;
          }

          #mpris {
            color: @pinks;
            font-size: 15px;
            padding-left: 5px;
            padding-right: 5px;
          }
          
          #custom-window-name {
            font-size: 15px;
            padding-left: 5px;
            padding-right: 5px;;
            color: #cad3f5;
          }

          #temperature {
            font-size: 15px;
            color: @teal;
            padding-left: 5px;
            padding-right: 5px;
          }

          #temperature.critical {
            background-color: @red;
          }

          #tray > .passive {
            -gtk-icon-effect: dim;
          }
          #tray > .needs-attention {
            -gtk-icon-effect: highlight;
          }

          #keyboard-state {
            color: @flamingo;
            padding-left: 5px;
            padding-right: 5px;
          }

          #workspaces button {
              box-shadow: none;
          	text-shadow: none;
              padding: 0px;
              border-radius: 9px;
              padding-left: 4px;
              padding-right: 4px;
              animation: gradient_f 20s ease-in infinite;
              transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.682);
          }

          #workspaces button:hover {
          	border-radius: 10px;
          	color: @overlay0;
          	background-color: @surface0;
           	padding-left: 2px;
              padding-right: 2px;
              animation: gradient_f 20s ease-in infinite;
              transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
          }

          #workspaces button.persistent {
          	color: @surface1;
          	border-radius: 10px;
          }

          #workspaces button.active {
          	color: @peach;
            	border-radius: 10px;
              padding-left: 8px;
              padding-right: 8px;
              animation: gradient_f 20s ease-in infinite;
              transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
          }

          #workspaces button.urgent {
          	color: @red;
           	border-radius: 0px;
          }

          #taskbar button.active {
              padding-left: 8px;
              padding-right: 8px;
              animation: gradient_f 20s ease-in infinite;
              transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
          }

          #workspaces button:nth-child(1) {
             color: #89b4fa;
              /* blue */
             margin: 0px 2px;
           }

         #workspaces button:nth-child(2) {
            color: #b4befe;
           /* lavender */
            margin: 0px 2px;
          }

         #workspaces button:nth-child(3) {
            color: #74c7ec;
            /* sapphire */
           margin: 0px 2px;
          }

         #workspaces button:nth-child(4) {
            color: #89dceb;
             /* sky */
             margin: 0px 2px;
          }

         #workspaces button:nth-child(5) {
            color: #94e2d5;
             /* teal */
            margin: 0px 2px;
          }

        #workspaces button:nth-child(6) {
            color: #a6e3a1;
            /* green */
            margin: 0px 2px;
          }

        #workspaces button:nth-child(7) {
            color: #f9e2af;
             /* yellow */
            margin: 0px 2px;
          }

        #workspaces button:nth-child(8) {
            color: #fab387;
             /* peach */
            margin: 0px 2px;
          }

        #workspaces button:nth-child(9) {
             color: #eba0ac;
               /* maroon */
            margin: 0px 2px;
          }

        #workspaces button:nth-child(10) {
             color: #f38ba8;
              /* red */
             margin: 0px 2px;
         }

          #taskbar button:hover {
              padding-left: 2px;
              padding-right: 2px;
              animation: gradient_f 20s ease-in infinite;
              transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
          }

          #custom-cava_mviz {
          	color: @pink;
          }

          #cava {
          	color: @pink;
          }

          #mpris {
          	color: @pink;
          }

          #custom-menu {
            color: @rosewater;
          }

          #custom-power {
            color: @red;
            padding-left: 5px;
            padding-right: 5px;
          }

          #custom-updater {
            color: @red;
          }

          #custom-light_dark {
            color: @blue;
          }

          #custom-weather {
           padding: 0.3rem 0.6rem;
           margin: 0.4rem 0.25rem;
           border-radius: 6px;
           color: #f9e2af;

          }

          #custom-weather.severe {
           color: #eb937d;
          }

          #custom-weather.sunnyDay {
           color: #c2ca76;
          }

          #custom-weather.clearNight {
           color: #2b2b2a;
          }

          #custom-weather.cloudyFoggyDay, #custom-weather.cloudyFoggyNight {
          color: #c2ddda;
          }

          #custom-weather.rainyDay, #custom-weather.rainyNight {
           color: #5aaca5;
          }

          #custom-weather.snowyIcyDay, #custom-weather.snowyIcyNight {
            color: #d6e7e5;
          }

          #custom-weather.default {
            color: #dbd9d8;
          }

          #custom-lock {
            color: @maroon;
          }

          #pulseaudio {
            color: @sapphire;
            font-size: 15px;
            padding-left: 5px;
            padding-right: 5px;
          }

          #pulseaudio.bluetooth {
            color: @pink;
          }
          #pulseaudio.muted {
            color: @red;
          }

          #window {
            color: @mauve;
          }

          #custom-waybar-mpris {
            color:@lavender;
          }

          #network {
            color: #cdd6f4;
            font-size: 15px;
            padding-left: 5px;
            padding-right: 5px;
          }
          #network.disconnected,
          #network.disabled {
            background-color: @surface0;
            color: @text;
          }
          #pulseaudio-slider slider {
          	min-width: 0px;
          	min-height: 0px;
          	opacity: 0;
          	background-image: none;
          	border: none;
          	box-shadow: none;
          }

          #pulseaudio-slider trough {
          	min-width: 80px;
          	min-height: 5px;
          	border-radius: 5px;
          }

          #pulseaudio-slider highlight {
          	min-height: 10px;
          	border-radius: 5px;
          }

          #backlight-slider slider {
          	min-width: 0px;
          	min-height: 0px;
          	opacity: 0;
          	background-image: none;
          	border: none;
          	box-shadow: none;
          }

          #backlight-slider trough {
          	min-width: 80px;
          	min-height: 10px;
          	border-radius: 5px;
          }

          #backlight-slider highlight {
          	min-width: 10px;
          	border-radius: 5px;
          }
        '';
      };
    })
  ];
}
