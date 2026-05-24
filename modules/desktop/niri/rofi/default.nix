{ pkgs, config, ... }: 

{
  home-manager.sharedModules = [
    ({ ... }: {

      programs.rofi = {
        enable = true;
        terminal = "kitty"; 
        extraConfig = import ./config.nix;

        theme = let
          mkLiteral = value: { _type = "literal"; inherit value; };
        in {
          # Global Properties
          "*" = {
            background = mkLiteral "#1E2127FF";
            background-alt = mkLiteral "#282B31FF";
            foreground = mkLiteral "#FFFFFFFF";
            selected = mkLiteral "#61AFEFFF";
            active = mkLiteral "#98C379FF";
            urgent = mkLiteral "#E06C75FF";
            font = "Iosevka Nerd Font 10";
          };

          # Main Window
          "window" = {
            transparency = "real";
            location = mkLiteral "center";
            anchor = mkLiteral "center";
            fullscreen = false;
            width = mkLiteral "750px";
            x-offset = mkLiteral "0px";
            y-offset = mkLiteral "0px";
            enabled = true;
            margin = mkLiteral "0px";
            padding = mkLiteral "0px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "12px";
            border-color = mkLiteral "@selected";
            
            # 💡 CHANGED: Hex color with alpha channel transparency (70% opacity)
            background-color = mkLiteral "#1E2127B3"; 
            cursor = "default";
          };

          # Main Box
          "mainbox" = {
            enabled = true;
            spacing = mkLiteral "20px";
            margin = mkLiteral "0px";
            padding = mkLiteral "20px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "0px 0px 0px 0px";
            border-color = mkLiteral "@selected";
            background-color = mkLiteral "transparent";
            children = map mkLiteral [ "inputbar" "listview" ];
          };

          # Inputbar
          "inputbar" = {
            enabled = true;
            spacing = mkLiteral "10px";
            margin = mkLiteral "0px";
            padding = mkLiteral "15px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "10px";
            border-color = mkLiteral "@selected";
            background-color = mkLiteral "white / 5%";
            text-color = mkLiteral "@foreground";
            children = map mkLiteral [ "prompt" "entry" ];
          };

          "prompt" = {
            enabled = true;
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "inherit";
          };

          "textbox-prompt-colon" = {
            enabled = true;
            expand = false;
            str = "::";
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "inherit";
          };

          "entry" = {
            enabled = true;
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "inherit";
            cursor = mkLiteral "text";
            placeholder = "Search";
            placeholder-color = mkLiteral "inherit";
          };

          # Listview
          "listview" = {
            enabled = true;
            columns = 5;
            lines = 3;
            cycle = true;
            dynamic = true;
            scrollbar = false;
            layout = mkLiteral "vertical";
            reverse = false;
            fixed-height = true;
            fixed-columns = true;
            spacing = mkLiteral "0px";
            margin = mkLiteral "0px";
            padding = mkLiteral "0px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "0px";
            border-color = mkLiteral "@selected";
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "@foreground";
            cursor = "default";
          };

          "scrollbar" = {
            handle-width = mkLiteral "5px";
            handle-color = mkLiteral "@selected";
            border-radius = mkLiteral "0px";
            background-color = mkLiteral "@background-alt";
          };

          # Elements
          "element" = {
            enabled = true;
            spacing = mkLiteral "15px";
            margin = mkLiteral "0px";
            padding = mkLiteral "20px 10px";
            border = mkLiteral "0px solid";
            border-radius = mkLiteral "10px";
            border-color = mkLiteral "@selected";
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "@foreground";
            orientation = mkLiteral "vertical";
            cursor = mkLiteral "pointer";
          };

          "element normal.normal" = {
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "@foreground";
          };

          "element selected.normal" = {
            background-color = mkLiteral "white / 5%";
            text-color = mkLiteral "@foreground";
          };

          "element-icon" = {
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "inherit";
            size = mkLiteral "64px";
            cursor = mkLiteral "inherit";
          };

          "element-text" = {
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "inherit";
            highlight = mkLiteral "inherit";
            cursor = mkLiteral "inherit";
            vertical-align = mkLiteral "0.5";
            horizontal-align = mkLiteral "0.5";
          };

          # Message & Errors
          "error-message" = {
            padding = mkLiteral "15px";
            border = mkLiteral "2px solid";
            border-radius = mkLiteral "10px";
            border-color = mkLiteral "@selected";
            background-color = mkLiteral "black / 10%";
            text-color = mkLiteral "@foreground";
          };

          "textbox" = {
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "@foreground";
            vertical-align = mkLiteral "0.5";
            horizontal-align = mkLiteral "0.0";
            highlight = mkLiteral "none";
          };
        };
      };
    })
  ];
}