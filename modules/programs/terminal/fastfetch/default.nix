{ config, pkgs, ... }:

let
  # Extract Stylix colors dynamically
  stylixColors = config.lib.stylix.colors or { };

  # Map labels directly to your Catppuccin palette strings
  # Utilizing standard base16 mapping conventions
  labels = "#${stylixColors.base0E or "cba6f7"}"; # Mauve (Primary Accent)
  kernelCol = "#${stylixColors.base0D or "89b4fa"}"; # Blue
  uptimeCol = "#${stylixColors.base0B or "a6e3a1"}"; # Green
  pkgsCol = "#${stylixColors.base08 or "f38ba8"}"; # Red
  shellCol = "#${stylixColors.base0A or "f9e2af"}"; # Yellow
  cpuCol = "#${stylixColors.base0C or "89dceb"}"; # Sapphire
  gpuCol = "#${stylixColors.base0C or "89dceb"}"; # Sapphire
  memCol = "#${stylixColors.base0F or "f5c2e7"}"; # Pink
  wmCol = "#${stylixColors.base09 or "fab387"}"; # Peach
  termCol = "#${stylixColors.base07 or "b4befe"}"; # Lavender
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
            source = ./nixos-logo.png;
            type = "sixel";
            /*
              padding = {
                top = 2;
                right = 4;
              };
            */
          };

          display = {
            separator = " ── ";
            color = {
              keys = "#${stylixColors.base0E or "cba6f7"}"; # Mauve Accent Separator
              title = "#${stylixColors.base05 or "cdd6f4"}"; # Default Text White
            };
          };

          modules = [
            {
              type = "title";
              color = {
                user = "#${stylixColors.base0E or "cba6f7"}"; # Mauve
                host = "#${stylixColors.base0F or "f5c2e7"}"; # Pink
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
              symbol = "circle";
              paddingLeft = 2;
            }
          ];
        };
      };
    })
  ];
}
