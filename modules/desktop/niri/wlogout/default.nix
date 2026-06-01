{ config, pkgs, ... }:

{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs.wlogout = {
          enable = true;

          layout = [
            {
              label = "lock";
              # Executes swaylock-effects with an instant screenshot blur
              action = "${pkgs.swaylock-effects}/bin/swaylock -f --screenshots --clock --indicator --effect-blur 7x5";
              text = "Lock";
              keybind = "l";
            }
            {
              label = "logout";
              action = "loginctl kill-session $XDG_SESSION_ID";
              text = "Logout";
              keybind = "e";
            }
            {
              label = "shutdown";
              action = "systemctl poweroff";
              text = "Shutdown";
              keybind = "s";
            }
            {
              label = "reboot";
              action = "systemctl reboot";
              text = "Reboot";
              keybind = "r";
            }
            {
              label = "hibernate";
              action = "systemctl hibernate";
              text = "Hibernate";
              keybind = "h";
            }
          ];

          style = ''
            window {
                font-family: "JetBrainsMono Nerd Font";
                font-size: 16pt;
                color: @theme_text_color
                background-color: rgba(0, 0, 0, 0.85);
            } 

            button {
                background-repeat: no-repeat;
                background-position: center;
                background-size: 20%;
                background-color: rgba(20, 20, 20, 0.5);
                border: 1px solid @theme_selected_bg_color;
                animation: gradient_f 20s ease-in infinite;
                transition: all 0.3s ease-in;
                box-shadow: 0 0 10px 2px transparent;
                border-radius: 36px;
                margin: 10px;
            }

            button:focus {
                box-shadow: none;
                background-size: 20%;
            }

            button:hover {
                background-size: 50%;
                box-shadow: 0 0 12px 3px @theme_selected_bg_color; 
                background-color: @theme_selected_bg_color; 
                color: @theme_base_color;
                transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.5s ease-in;
            }

            #shutdown { background-image: image(url("icons/power.png")); }
            #shutdown:hover { background-image: image(url("icons/power-hover.png")); }

            #logout { background-image: image(url("icons/logout.png")); }
            #logout:hover { background-image: image(url("icons/logout-hover.png")); }

            #reboot { background-image: image(url("icons/restart.png")); }
            #reboot:hover { background-image: image(url("icons/restart-hover.png")); }

            #lock { background-image: image(url("icons/lock.png")); }
            #lock:hover { background-image: image(url("icons/lock-hover.png"));

            #hibernate { background-image: image(url("icons/hibernate.png")); }
            #hibernate:hover { background-image: image(url("icons/hibernate-hover.png")); }
          '';
        };

        xdg.configFile."wlogout/icons" = {
          source = ./path/to/your/local/icons;
          recursive = true;
        };
      }
    )
  ];
}
