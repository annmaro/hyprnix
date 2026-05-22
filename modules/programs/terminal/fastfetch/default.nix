{ config, pkgs, ... }:

let
  # Brand New Color Palette (Catppuccin Mocha)
  labels     = "#89b4fa"; # Blue
  kernelCol  = "#cba6f7"; # Mauve
  uptimeCol  = "#a6e3a1"; # Green
  pkgsCol    = "#eba0ac"; # Maroon
  shellCol   = "#f9e2af"; # Yellow
  cpuCol     = "#94e2d5"; # Teal
  gpuCol     = "#89dceb"; # Sky
  memCol     = "#f5c2e7"; # Pink
  wmCol      = "#fab387"; # Peach
  termCol    = "#89b4fa"; # Blue
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
            source = "nixos"; # Uses fastfetch's beautiful built-in sleek NixOS logo
            padding = {
              top = 2;
              right = 4;
            };
          };

          display = {
            separator = " ── ";
            color = {
              keys = "magenta";
              title = "blue";
            };
          };

          modules = [
            {
              type = "title";
              color = {
                user = "blue";
                host = "mauve";
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
              symbol = "block";
              paddingLeft = 2;
            }
          ];
        };
      };
    })
  ];
}