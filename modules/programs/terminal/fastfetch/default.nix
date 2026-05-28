{ config, pkgs, ... }:

let
  # Re-mapped to standard ANSI naming aliases matching our new Gruvbox values
  labels     = "blue";    # Gruvbox Blue (83a598)
  kernelCol  = "magenta"; # Gruvbox Purple (d3869b)
  uptimeCol  = "green";   # Gruvbox Green (b8bb26)
  pkgsCol    = "red";     # Gruvbox Red (fb4934)
  shellCol   = "yellow";  # Gruvbox Yellow/Gold (fabd2f)
  cpuCol     = "cyan";    # Gruvbox Aqua/Cyan (8ec07c)
  gpuCol     = "cyan";    # Gruvbox Aqua/Cyan (8ec07c)
  memCol     = "magenta"; # Gruvbox Purple (d3869b)
  wmCol      = "yellow";  # Gruvbox Orange/Yellow (fe8019 / fabd2f)
  termCol    = "blue";    # Gruvbox Blue (83a598)
in
{
  home-manager.sharedModules = [
    (_: {   
      programs.fastfetch = {
        enable = true;
        package = pkgs.fastfetch;
        settings = {
          "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
        
          logo = {
            source = "./nixos.png".;
            padding = {
              top = 2;
              right = 4;
            };
          };

          display = {
            separator = " ── ";
            color = {
              keys = "yellow"; /* Swapped separator color to Gruvbox Gold */
              title = "blue";
            };
          };

          modules = [
            {
              type = "title";
              color = {
                user = "blue";
                host = "magenta";
              };
            }
            "break"
            {
              type = "os";
              key = "󱄅 os";
              keyColor = labels;
            }
            {
              type = "kernel";
              key = "󰌽 kernel";
              keyColor = kernelCol;
            }
            {
              type = "uptime";
              key = "󱎫 uptime";
              keyColor = uptimeCol;
            }
            {
              type = "packages";
              key = "󰏖 packages";
              keyColor = pkgsCol;
            }
            {
              type = "shell";
              key = "󱆃 shell";
              keyColor = shellCol;
            }
            "break"
            {
              type = "cpu";
              key = "󰻠 cpu";
              keyColor = cpuCol;
            }
            {
              type = "gpu";
              key = "󰢮 gpu";
              keyColor = gpuCol;
            }
            {
              type = "memory";
              key = "󰍛 memory";
              keyColor = memCol;
            }
            {
              type = "wm";
              key = " wm";
              keyColor = wmCol;
            }
            {
              type = "terminal";
              key = " terminal";
              keyColor = termCol;
            }
            "break"
            {
              type = "colors";
              symbol = "circle"; /* Swapped from block to circular dots */
              paddingLeft = 2;
            }
          ];
        };
      };
    })
  ];
}