{ host, pkgs, inputs, lib, ... }:

let
  inherit (lib.trivial) importJSON;
  inherit (import ../../../../../hosts/${host}/variables.nix) clock24h;
in
{
 
  home-manager.sharedModules = [
    (_: {

    programs.hyprpanel = {
     enable = false;
      settings = {
         theme = (importJSON ./catppuccin_mocha.json) // {
        # name = "catppuccin_mocha";
        
        font = {
          name = "JetBrainsMonoNF-Regular";
          size = "16px";
        };
        };
      scalingPriority = "hyprland";
        bar = {
          launcher.autoDetectIcon = true;
          clock.format = "%a %d %b %R";
          battery.hideLabelWhenFull = true;
          workspaces = {
                    show_icons = true;
                    # ignored = "-";
                };

        layouts = {
         "0" = {
          left = [
               "dashboard"
               "cpu"
               "memory"
               "custom/gpuinfo" 
               "cputemp"
               "windowtitle"
              ];
               middle = [
                "workspaces"
              ];
               right = [
                 "media"
                 "weather"
                 "battery"
                 "volume"
                 "network"
                 "bluetooth"
                 "systray"
                 "clock"
                 "notifications"
                 "power"
               ];   
              };
        };
      };

      
       menus.clock = {
          time = {
          military = true;
          hideSeconds = true;
        };

        weather = {
          location = "Ramgarh";
          unit = "metric";
          key = "/home/anand/weather.json";
      };
      };

        custom-gpuinfo = {
          icon = "";
          execute = "${../../scripts/gpuinfo.sh}";
          return-type = "json";
          label = "{0}";
          onLeftClick = "${../../scripts/gpuinfo.sh} --toggle";
          interval = 5; # once every 5 seconds
          tooltip = true;
        };

      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = true;
     
         
      };
      };
    })
  ];
} 
      




