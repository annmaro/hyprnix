{
  self,
  host,
  pkgs,
  ...
}:
let
  inherit (import "${self}/hosts/${host}/variables.nix") clock24h;
  gpuinfo = pkgs.callPackage (self + "/modules/desktop/niri/scripts/gpuinfo.nix") { };
  window_name = pkgs.callPackage (self + "/modules/desktop/niri/scripts/window_name.nix") { };
  keyboardswitch = pkgs.callPackage (self + "/modules/desktop/niri/scripts/keyboardswitch.nix") { };
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
            mode = "dock";
            exclusive = true;
            passthrough = false;
            gtk-layer-shell = true;
            ipc = true;
            fixed-center = true;
            margin-top = 0;
            margin-left = 0;
            margin-right = 0;
            margin-bottom = 0;

            modules-left = [
              "group/gleft1"
              "custom/window-name"
            ];
            modules-center = [
              "niri/workspaces"
              "mpris"
            ];
            modules-right = [
              "custom/weather"
              "group/gright1"
              "clock"
              "group/gright2"
            ];

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
                notification = "<span foreground='#fabd2f'><sup></sup></span>";
                none = "";
                dnd-notification = "<span foreground='#fabd2f'><sup></sup></span>";
                dnd-none = "";
              };
              return-type = "json";
              exec-if = "which swaync-client";
              exec = "swaync-client -swb";
              on-click = "swaync-client -t -sw";
              on-click-right = "swaync-client -d -sw";
              escape = true;
            };

            "custom/gpuinfo" = {
              exec = "${gpuinfo}/bin/gpuinfo";
              return-type = "json";
              format = "{0}";
              interval = 5;
              tooltip = true;
            };

            "custom/icon" = {
              format = " ";
            };

            "mpris" = {
              format = "{player_icon} {title} - {artist}";
              format-paused = "{status_icon} <i>{title} - {artist}</i>";
              player-icons = {
                default = "▶";
                spotify = "";
                mpv = "󰐹";
              };
              status-icons = {
                paused = "⏸";
                playing = "";
              };
              max-length = 30;
            };

            "temperature" = {
              critical-threshold = 88;
              format = "{icon} {temperatureC}°C";
              format-icons = [
                ""
                ""
                ""
              ];
            };

            "niri/language" = {
              format = "{short}";
            };

            "niri/workspaces" = {
              all-outputs = true;
              format = "{icon}";
              format-icons = {
                default = "";
                active = "";
                urgent = "";
              };
            };

            "niri/window" = {
              format = "  {}";
              separate-outputs = true;
            };

            "clock" = {
              format = if clock24h == true then "{:%a %d %b %R}" else "{:%a %d %b %I:%M %p}";
              format-alt = if clock24h == true then "{:%a %d %b %I:%M %p}" else "{:%a %d %b %R}";
              tooltip-format = "<tt><big>{calendar}</big></tt>";
            };

            "cpu" = {
              interval = 10;
              format = "󰍛 {usage}%";
            };
            "memory" = {
              interval = 30;
              format = "󰾆 {percentage}%";
            };

            /*
              "custom/weather" = {
                exec = "${self + "/modules/desktop/niri/scripts/weather.sh"}";
                restart-interval = 600;
                return-type = "json";
              };
            */

            "backlight" = {
              format = "{icon} {percent}%";
              format-icons = [
                ""
                ""
                ""
              ];
            };

            "network" = {
              format-wifi = "📡 Starlink";
              format-ethernet = "󱘖 Wired";
              format-disconnected = "󰤮 Disconnected";
              interval = 5;
            };

            "pulseaudio" = {
              format = "{icon} {volume}";
              format-muted = " ";
              format-icons = {
                default = [
                  ""
                  ""
                  ""
                ];
              };
            };

            "tray" = {
              icon-size = 20;
              spacing = 5;
            };

            "battery" = {
              states = {
                warning = 30;
                critical = 20;
              };
              format = "{icon} {capacity}%";
              format-charging = " {capacity}%";
            };

            "custom/window-name" = {
              format = "<b>{}</b>";
              interval = 1;
              exec = "${window_name}/bin/window_name";
            };
            "custom/power" = {
              format = "{}";
              on-click = "wlogout -b 4";
            };
          }
        ];
        style = ''
            /* Base Elements inherit directly from Stylix Theme engine */
            * {
              font-family: "JetBrainsMono Nerd Font";
              font-size: 16px;
            }

            window#waybar {
              background-color: rgba(20, 20, 20, 0.5); /* Slight translucent tint */
              border-bottom: 2px solid transparent; /* Clean border by default */
            }

            /* Modular grouping containers */
            #gleft1, #gright1, #gright2, #custom-window-name, #custom-weather, #clock, #mpris, #workspaces {
              background-color: rgba(20, 20, 20, 0.5); /* Slight translucent tint for amoled depth */
              border: 1px solid @theme_selected_bg_color; /* Border styled natively by Gruvbox Yellow */
              border-radius: 30px;
              margin: 4px;
              padding: 5px 5px;
              font-size: 18px;
              font-weight: bold;            /* Forces text to be bold */
              color: @theme_text_color;
            }

            #workspaces button {
              font-weight: bold;
              color: @theme_text_color;
              padding: 0px 6px;           /* Control space on the left/right of the dots */
              margin: 0px 2px;            /* Slight gap between the dots */
              background: transparent;     /* Ensure inactive buttons stay transparent */
              border-bottom: none;        /* Kills the weird white underline/border */
              box-shadow: none;           /* Prevents GTK theme shadows from bleeding through */
          }

            /* Active / Highlight states target Stylix Selection Colors */
            #workspaces button.active {
              color: transparent;
              background-color: @theme_selected_bg_color;
              border-radius: 12px;          /* Slightly tighter radius for a cleaner pill */
              min-width: 45px;              /* Increased to make it a wide pill */
              padding: 0px 8px;             /* Tighter padding so the pill hugs the text/icon */
              margin: 4px 2px;              /* Subtle spacing between pills */
              transition: all 0.3s ease-in-out;
            }

            #workspaces button.urgent {
              color: #ff5555;
            }

            #workspaces button:hover {
            color: @theme_selected_bg_color;
            border-radius: 16px;
            min-width: 50px;
            background-size: 300% 300%;
            }

            #battery.critical:not(.charging) {
              background-color: #ff5555;
              color: @theme_base_color;
            }

            tooltip {
              background-color: @theme_base_color;
              border: 1px solid @theme_selected_bg_color;
            }
            tooltip label {
              color: @theme_text_color;
            }
            #custom-window-name {
              border-radius: 30px;
              padding: 0px 0px 0px 5px;
              min-width: 80px;
              background: transparent;
            }
            #custom-power {
              padding-left: 5px;
              padding-right: 5px;
            }
            #bluetooth {
              font-size: 15px;
              padding-left: 5px;
              padding-right: 5px;
            }
            #custom-notification {
              padding-left: 5px;
              padding-right: 5px;
            }
            #custom-icon {
            padding-left: 2px;
            padding-right: 5px;
          }
          #cpu {
            padding-left: 5px;
            padding-right: 5px;
          }
          #memory {
            padding-left: 5px;
            padding-right: 5px;
          }
          #temperature {
            padding-left: 5px;
            padding-right: 5px;
          }
          #network {
            padding-left: 5px;
            padding-right: 5px;
          }
          #pulseaudio {
            padding-left: 5px;
            padding-right: 5px;
          }

        '';
      };
    })
  ];
}
