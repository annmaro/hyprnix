# 🛠️ FIXED: Removed 'theme' from here to avoid system evaluation crashes
{ pkgs, config, ... }: 

{
  home-manager.sharedModules = [
    # 🛠️ FIXED: Changed from (_: { to ({ ... }: { to avoid dropping module context
    ({ ... }: {

      programs.rofi = {
        enable = true;
        terminal = "kitty"; 
        extraConfig = import ./config.nix;

        theme = let
          mkLiteral = value: { _type = "literal"; inherit value; };
        in {
          "*" = {
            font = "JetBrains Mono Nerd Font 10";
            background = mkLiteral "#180F39";
            background-alt = mkLiteral "#32197D";
            foreground = mkLiteral "#FFFFFF";
            selected = mkLiteral "#FF00F1";
            active = mkLiteral "#9878FF";
            urgent = mkLiteral "#7D0075";
          };

          "window" = {
            transparency = "real";
            location = mkLiteral "center";
            anchor = mkLiteral "center";
            fullscreen = false;
            width = mkLiteral "1000px";
            x-offset = mkLiteral "0px";
            y-offset = mkLiteral "0px";
            enabled = true;
            border-radius = mkLiteral "20px";
            cursor = "default";
            background-color = mkLiteral "@background";
          };

          "mainbox" = {
            enabled = true;
            spacing = mkLiteral "0px";
            background-color = mkLiteral "transparent";
            orientation = mkLiteral "vertical";
            children = map mkLiteral [ "inputbar" "listbox" ];
          };

          "listbox" = {
            spacing = mkLiteral "20px";
            padding = mkLiteral "20px";
            background-color = mkLiteral "transparent";
            orientation = mkLiteral "vertical";
            children = map mkLiteral [ "message" "listview" ];
          };

          "inputbar" = {
            enabled = true;
            spacing = mkLiteral "10px";
            padding = mkLiteral "80px 60px";
            background-color = mkLiteral "transparent";
            # 🌟 BEAUTIFUL: Nix evaluates this path directly into the Nix Store!
            background-image = mkLiteral "url(\"${./images/telescope-best.jpg}\")";
            text-color = mkLiteral "@foreground";
            orientation = mkLiteral "horizontal";
            children = map mkLiteral [ "textbox-prompt-colon" "entry" "dummy" "mode-switcher" ];
          };

          "textbox-prompt-colon" = {
            enabled = true;
            expand = false;
            str = "";
            padding = mkLiteral "12px 15px";
            border-radius = mkLiteral "100%";
            background-color = mkLiteral "@background-alt";
            text-color = mkLiteral "inherit";
          };

          "entry" = {
            enabled = true;
            expand = false;
            width = mkLiteral "300px";
            padding = mkLiteral "12px 16px";
            border-radius = mkLiteral "100%";
            background-color = mkLiteral "@background-alt";
            text-color = mkLiteral "inherit";
            cursor = mkLiteral "text";
            placeholder = "Search";
            placeholder-color = mkLiteral "inherit";
          };

          "dummy" = {
            expand = true;
            background-color = mkLiteral "transparent";
          };

          "mode-switcher" = {
            enabled = true;
            spacing = mkLiteral "10px";
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "@foreground";
          };

          "button" = {
            width = mkLiteral "80px";
            padding = mkLiteral "12px";
            border-radius = mkLiteral "100%";
            background-color = mkLiteral "@background-alt";
            text-color = mkLiteral "inherit";
            cursor = mkLiteral "pointer";
          };

          "button selected" = {
            background-color = mkLiteral "@selected";
            text-color = mkLiteral "@foreground";
          };

          "listview" = {
            enabled = true;
            columns = 2;
            lines = 8;
            cycle = true;
            dynamic = true;
            scrollbar = false;
            layout = mkLiteral "vertical";
            reverse = false;
            fixed-height = true;
            fixed-columns = true;
            spacing = mkLiteral "10px";
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "@foreground";
            cursor = "default";
          };

          "element" = {
            enabled = true;
            spacing = mkLiteral "10px";
            padding = mkLiteral "4px";
            border-radius = mkLiteral "100%";
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "@foreground";
            cursor = mkLiteral "pointer";
          };

          "element normal.normal" = {
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
          };

          "element normal.urgent" = {
            background-color = mkLiteral "@urgent";
            text-color = mkLiteral "@foreground";
          };

          "element normal.active" = {
            background-color = mkLiteral "@active";
            text-color = mkLiteral "@foreground";
          };

          "element selected.normal" = {
            background-color = mkLiteral "@selected";
            text-color = mkLiteral "@foreground";
          };

          "element selected.urgent" = {
            background-color = mkLiteral "@urgent";
            text-color = mkLiteral "@foreground";
          };

          "element selected.active" = {
            background-color = mkLiteral "@urgent";
            text-color = mkLiteral "@foreground";
          };

          "element-icon" = {
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "inherit";
            size = mkLiteral "32px";
            cursor = mkLiteral "inherit";
          };

          "element-text" = {
            background-color = mkLiteral "transparent";
            text-color = mkLiteral "inherit";
            cursor = mkLiteral "inherit";
            vertical-align = mkLiteral "0.5";
            horizontal-align = mkLiteral "0.0";
          };

          "message" = {
            background-color = mkLiteral "transparent";
          };

          "textbox" = {
            padding = mkLiteral "12px";
            border-radius = mkLiteral "100%";
            background-color = mkLiteral "@background-alt";
            text-color = mkLiteral "@foreground";
            vertical-align = mkLiteral "0.5";
            horizontal-align = mkLiteral "0.0";
          };

          "error-message" = {
            padding = mkLiteral "12px";
            border-radius = mkLiteral "20px";
            background-color = mkLiteral "@background";
            text-color = mkLiteral "@foreground";
          };
        };
      };
    })
  ];
}