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
          targets = "graphical-session.target";
        };
        settings = [
          {
            layer = "top";
            position = "top";
            mode = "dock"; # Fixes fullscreen issues
            height = 48; # 35
            exclusive = true;
            passthrough = false;
            gtk-layer-shell = true;
            ipc = true;
            fixed-center = true;
            margin-top = 5;
            margin-left = 5;
            margin-right = 5;
            margin-bottom = 0;

            modules-left = [
              "group/gleft1"
              "custom/window-name"
             ];
            modules-center = [
              "hyprland/workspaces"
              "mpris"
            ];
            modules-right = [
              "custom/weather"
              "group/gright1"
              "clock"
              "group/gright2"
            ];
            # Declaring the groups
            "group/gleft1" = {
              "orientation" = "horizontal";
              modules = [
               "custom/icon"
               "cpu"
               "memory"
               "custom/gpuinfo" 
               "temperature"
              ];
            };
                    
            "group/gright1" = {
              "orientation" = "horizontal";
              modules = [
              "battery"
              "backlight"
              "pulseaudio"
              "network"
              ];
            };
            
            "group/gright2" = {
              "orientation" = "horizontal";
              modules = [
               "tray"
               "custom/notification"
               "custom/power"
              ];
            };
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
              active = "";  
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
             on-click = "pkill -USR1 waybar-weather";
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
              format-wifi = "📡 Starlink";
              # format-wifi = " {bandwidthDownBits}  {bandwidthUpBits}";
              # format-wifi = "  {essid}";
              format-ethernet = "󱘖 Wired";
              # format-ethernet = " {bandwidthDownBits}  {bandwidthUpBits}";
              #format-linked = "󰤪 Secure";
              format-linked = "󱘖 {ifname} (No IP)";
              #format-disconnected = "󰤮 Off";
              format-disconnected = "󰤮 Disconnected";
              # format-alt = "󰤨 {signalStrength}%";
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
              icon-size = 20;
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
            font-family: "JetBrainsMono Nerd Font";
            font-size: 16px;
            border: none;
            border-radius: 0px;
            min-height: 0;
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
           background: transparent;
           
          }

          window#waybar.hidden {
            opacity: 0.2;
          }

         
          #pill#1 {
            color: @pinks;
            background: @theme_base_color;
            padding-left: 5px;
            padding-right: 5px;
          }
          
          #gleft1, #gright1 {
             padding: 0px 0px 0px 5px;
             margin: 6px 10px 2px 3px;
             border: 3px solid rgba(14, 14, 14, .1);
             border-radius:30px;
             background: @theme_base_color;
             box-shadow: 0 0 2px rgba(0, 0, 0, 0.6);
            transition: all .3s ease; 
            min-width: 120px;
          }
           
          #gright2 {
             margin: 6px 10px 2px 3px;
             border: 3px solid rgba(14, 14, 14, .1);
             border-radius:30px;
             background: @theme_base_color;
             box-shadow: 0 0 2px rgba(0, 0, 0, 0.6);
             padding: 0px 0px 0px 5px;
            transition: all .3s ease; 
          } 

          #custom-window-name {
            padding: 0px;
            margin: 6px 10px 2px 3px;
            border: 3px solid rgba(14, 14, 14, .1);
            border-radius: 30px;
            padding: 0px 0px 0px 5px;;
            color: #cad3f5;
            min-width: 80px;
            background: @theme_base_color;
          }

          #temperature {
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

         #workspaces {
          background: @theme_base_color;
          margin: 5px 5px;
          padding: 8px 5px;
          border-radius: 30px;
          color: #cba6f7
         }
         #workspaces button {
          padding: 0px 5px;
          margin: 0px 3px;
          border-radius: 30px;
          color: @teal;
          background: transparent;
          transition: all 0.3s ease-in-out;
         }

         #workspaces button.active {
           background-color: @teal;
           color: @teal;
           border-radius: 16px;
           min-width: 50px;
           background-size: 300% 300%;
          transition: all 0.3s ease-in-out;
         }

        #workspaces button:hover {
          background-color: @maroon;
          color: @maroon;
          border-radius: 16px;
          min-width: 50px;
          background-size: 400% 400%;
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

           tooltip {
            background: #1e1e2e;
            border-radius: 8px;
          }

          tooltip label {
            color: #cad3f5;
            margin-right: 5px;
            margin-left: 5px;
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
             color: @rosewater;
             padding-left: 5px;
             padding-right: 5px;
          }

          #battery {
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
            background: @theme_base_color;
            padding: 0px;
            margin: 6px 10px 2px 2px;
            border-radius: 30px;
             padding-left: 5px;
            padding-right: 5px;
            transition: all .3s ease; 
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
            background: @theme_base_color;
            padding: 0px;
            margin: 6px 10px 2px 2px;
            border-radius: 30px;
            padding-left: 5px;
            padding-right: 5px;
            transition: all .3s ease; 
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
           padding: 0px;
           margin: 6px 10px 2px 2px;
           border: 3px solid rgba(14, 14, 14, .1);
           border-radius: 30px;
           color: #f9e2af;
           background: @theme_base_color;
            padding-left: 5px;
            padding-right: 5px;
           transition: all .3s ease;
          }

          /* Classes from waybar-weather: waybar-weather, alt-view, cold, hot, rain, snow, smoke */
          #custom-weather.waybar-weather.alt-view {
            font-style: italic;
          }

          #custom-weather.waybar-weather.hot {
            color: #a91313;
          }

          #custom-weather.waybar-weather.cold {
            color: #5fa4ec;
          }

          @keyframes blink-condition {
            to {
              opacity: 0.55;
            }
          }

          #custom-weather.waybar-weather.rain,
          #custom-weather.waybar-weather.snow,
          #custom-weather.waybar-weather.smoke {
            animation-name: blink-condition;
            animation-duration: 1s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
          }

          #custom-lock {
            color: @maroon;
          }

          #pulseaudio {
            color: @sapphire;
            padding-left: 5px;
            padding-right: 5px;
          }

          #pulseaudio.bluetooth {
            color: @pink;
            background: @theme_base_color;
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
            color: #EE2091;
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
