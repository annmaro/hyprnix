{ pkgs, config, ... }:

{
  home-manager.sharedModules = [
    (_: {
      # 1. Ensure the banner image is correctly linked via Home Manager
      xdg.configFile."rofi/images/telescope-fast.jpg".source = ./images/telescope-fast.jpg;

      programs.rofi = {
        enable = true;
        terminal = "kitty";

        extraConfig = import ./config.nix;

        
        # 2. Native Nix adaptation of your style-2.rasi theme configurations
        theme = let
          # Use inherit to grab the global variables defined below
          inherit (pkgs.formats.rasi) mkLiteral;
        in {
          # Global Properties
          "*" = {
            font = "JetBrains Mono Nerd Font 10";
            background = mkLiteral "#180F39";
            background-alt = mkLiteral "#32197D";
            foreground = mkLiteral "#FFFFFF";
            selected = mkLiteral "#FF00F1";
            active = mkLiteral "#9878FF";
            urgent = mkLiteral "#7D0075";
          };

          # Main Window
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

          # Main Box
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

          # Inputbar
          "inputbar" = {
            enabled = true;
            spacing = mkLiteral "10px";
            padding = mkLiteral "80px 60px";
            background-color = mkLiteral "transparent";
            # Dynamically reads from your home profile directly to fix the ~ path parsing bug!
            background-image = mkLiteral "url(\"file://${config.home.homeDirectory}/.config/rofi/images/telescope-best.jpg\")";
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

          # Mode Switcher
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

          # Listview
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

          # Elements
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

          # Messages
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