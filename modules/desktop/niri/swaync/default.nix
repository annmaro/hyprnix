{ config, pkgs, ... }:

{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        services.swaync = {
          enable = true;

          # Declarative conversion of configSchema settings
          settings = {
            "$schema" = "/etc/xdg/swaync/configSchema.json";
            positionX = "right";
            positionY = "top";
            cssPriority = "user";

            control-center-width = 380;
            control-center-height = 860;
            control-center-margin-top = 2;
            control-center-margin-bottom = 2;
            control-center-margin-right = 1;
            control-center-margin-left = 0;

            notification-window-width = 400;
            notification-icon-size = 48;
            notification-body-image-height = 160;
            notification-body-image-width = 200;

            timeout = 4;
            timeout-low = 2;
            timeout-critical = 6;

            fit-to-screen = false;
            keyboard-shortcuts = true;
            image-visibility = "when-available";
            transition-time = 200;
            hide-on-clear = false;
            hide-on-action = false;
            script-fail-notify = true;

            widgets = [
              "label"
              "buttons-grid"
              "mpris"
              "title"
              "dnd"
              "notifications"
            ];

            widget-config = {
              title = {
                text = "Notifications";
                clear-all-button = true;
                button-text = " 󰎟 ";
              };
              dnd = {
                text = "Do not disturb";
              };
              label = {
                max-lines = 1;
                text = " ";
              };
              mpris = {
                image-size = 96;
                image-radius = 12;
              };
              volume = {
                label = "󰕾";
                show-per-app = true;
              };
              buttons-grid = {
                actions = [
                  {
                    label = " ";
                    command = "amixer set Master toggle";
                  }
                  {
                    label = "";
                    command = "amixer set Capture toggle";
                  }
                  {
                    label = " ";
                    command = "nm-connection-editor";
                  }
                  {
                    label = "󰂯";
                    command = "blueman-manager";
                  }
                  {
                    label = "󰏘";
                    command = "nwg-look";
                  }
                ];
              };
            };
          };

          # Unified style definitions integrated directly with Stylix System variables
          style = ''
            * {
              color: @theme_text_color;
              all: unset;
              font-size: 14px;
              font-family: "JetBrainsMono Nerd Font";
              transition: 200ms;
            }

            .blank-window {  
              background: transparent; 
            }

            /* CONTROL CENTER PANEL (Translucent for Niri window blur matching screenshot-20260601-202011.png) */
            .control-center {
              background: rgba(0, 0, 0, 0.45);
              border-radius: 24px;
              border: 1px solid @theme_selected_bg_color; /* Linked directly to your Gruvbox Yellow */
              box-shadow: 0 0 10px 0 rgba(0,0,0,.6);
              margin: 18px;
              padding: 12px;
            }

            /* FLOATING NOTIFICATION POPUPS */
            .notification-row {
              outline: none;
              margin: 0;
              padding: 0px;
            }

            .floating-notifications.background .notification-row .notification-background {
              background: rgba(0, 0, 0, 0.55);
              box-shadow: 0 0 8px 0 rgba(0,0,0,.6);
              border: 1px solid @theme_selected_bg_color;
              border-radius: 24px;
              margin: 16px;
              padding: 0;
            }

            .floating-notifications.background .notification-row .notification-background .notification {
              padding: 6px;
              border-radius: 12px;
            }

            .floating-notifications.background .notification-row .notification-background .notification.critical {
              border: 2px solid #dd0000;
            }

            .control-center .notification-row .notification-background {
              background-color: rgba(25, 25, 25, 0.4);
              border-radius: 16px;
              margin: 4px 0px;
              padding: 4px;
            }

            .control-center .notification-row .notification-background .notification.critical {
              color: #dd0000;
            }

            /* ACTION BUTTONS & INTERFACES */
            .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action {
              background: rgba(254, 189, 47, 0.2);
              color: @theme_text_color;
              border-radius: 12px;
              margin: 6px;
            }

            .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action:hover {
              background: @theme_selected_bg_color;
              color: @theme_base_color;
            }

            /* WIDGET ARCHITECTURE MAPPINGS */
            .widget-title button {
              background: rgba(25, 25, 25, 0.5);
              border-radius: 6px;
              padding: 4px 16px;
            }

            .widget-title button:hover {
              background-color: @theme_selected_bg_color;
              color: @theme_base_color;
            }

            .widget-dnd > switch {
              background: rgba(25, 25, 25, 0.5);
              border-radius: 8px;
              padding: 2px;
            }

            .widget-dnd > switch:checked {
              background: @theme_selected_bg_color;
            }

            .widget-dnd > switch slider {
              background: @theme_text_color;
              border-radius: 6px;
            }

            .widget-buttons-grid {
              padding: 6px 2px;
              margin: 6px;
              border-radius: 12px;
              background: rgba(25, 25, 25, 0.4);
            }

            .widget-buttons-grid>flowbox>flowboxchild>button {
              margin: 4px 10px;
              padding: 6px 12px;
              background: transparent;
              border-radius: 8px;
            }

            .widget-buttons-grid>flowbox>flowboxchild>button:hover {
              background: @theme_selected_bg_color;
              color: @theme_base_color;
            }

            /* MEDIA PLAYER (MPRIS) INTERFACE */
            .widget-mpris {
              background: rgba(25, 25, 25, 0.4);
              border-radius: 16px;
              color: @theme_text_color;
              margin: 20px 6px;
            }

            .widget-mpris-player {
              background-color: rgba(0, 0, 0, 0.3);
              border-radius: 22px;
              padding: 6px 14px;
              margin: 6px;
            }

            .widget-mpris-album-art {
              border-radius: 16px;
            }

            picture.mpris-background {
              opacity: 0;
            }
          '';
        };
      }
    )
  ];
}
