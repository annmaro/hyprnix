{ config, pkgs, ... }:

let 
  nord9 = "#81A1C1";
  nord10 = "#5E81AC";
  nord11 = "#BF616A";
  nord13 = "#EBCB8B";
  nord14 = "#A3BE8C";

in {

  home-manager.sharedModules = [
    (_: {   
  programs.fastfetch = {
    enable = true;
    package = pkgs.fastfetch;
    settings = {
      "$schema" = "https:#github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
    
      logo = {
        source = ./nixos.png;
        height = 15;
        width = 30;
        padding = {
          top = 10;
          left = 3;
        };
      };

      modules = [
        "break"
        {
          type = "command";
          text = "echo \${USER}@\${HOSTNAME}";
          key = "      ";
          keyColor = nord10;
        }
        {
          type = "custom";
          format = "┌──────────────────────Hardware──────────────────────┐";
        }
        {
          type = "host";
          key = "   PC";
          keyColor = nord11;
        }
        {
          type = "cpu";
          key = "   CPU";
          showPeCoreCount = true;
          keyColor = nord14;
        }
        {
          type = "gpu";
          key = "  󰊴 GPU";
          keyColor = nord14;
        } 
        {
          type = "memory";
          key = "  󰑭 Memory";
          keyColor = nord13;
        }
        {
          type = "disk";
          key = "   Disk";
          keyColor = nord13;
        }
        {
          type = "display";
          key = "  󰍹 Display";
          keyColor = nord13;
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────────────────┘";
        }
        "break"
        {
          type = "custom";
          format = "┌──────────────────────Software──────────────────────┐";
        }
        {
          type = "os";
          key = "   OS";
          keyColor = nord11;
        }
        {
          type = "kernel";
          key = "   Kernel";
          keyColor = nord11;
        }
        {
          type = "packages";
          key = "  󰏖 Packages";
          keyColor = nord13;
        }  
        {
          type = "de";
          key = " DE";
          keyColor = nord13;
        }
        {
          type = "wm";
          key = "   WM";
          keyColor = nord13;
        }
        {
          type = "terminal";
          key = "   Terminal";
          keyColor = nord14;
        }
        {
          type = "shell";
          key = "   Shell";
          keyColor = nord14;
        } 
        {
          type = "custom";
          format = "└────────────────────────────────────────────────────┘";
        }
        "break"
        {
          type = "custom";
          format = "┌────────────────────Uptime / Age────────────────────┐";
        }
        {
          type = "command";
          key = "  OS Age";
          keyColor = nord11;
          text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
        }
        {
          type = "uptime";
          key = "  Uptime";
          keyColor = nord11;
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────────────────┘";
        }
        {
            type = "colors";
            paddingLeft = 2;
            symbol = "circle";
        }
        "break"
	    ];
    };
  };
    })
  ];
}
