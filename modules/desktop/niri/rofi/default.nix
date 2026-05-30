{ pkgs, config, ... }:

{
  home-manager.sharedModules = [
    (
      { ... }:
      {

        programs.rofi = {
          enable = true;
          terminal = "kitty";
          extraConfig = import ./config.nix;

          theme =
            let
              mkLiteral = value: {
                _type = "literal";
                inherit value;
              };
            in
            {
              "*" = {
                font = "JetBrains Mono Nerd Font 12";
              };

              "window" = {
                transparency = "real";
                location = mkLiteral "center";
                anchor = mkLiteral "center";
                fullscreen = false;
                width = mkLiteral "800px";
                x-offset = mkLiteral "0px";
                y-offset = mkLiteral "0px";
                enabled = true;
                margin = mkLiteral "0px";
                padding = mkLiteral "0px";
                border-radius = mkLiteral "20px";
                cursor = "default";
                # CHANGED: Swapped solid AMOLED black for 80% transparent black
                background-color = mkLiteral "#000000cc";
              };

              "mainbox" = {
                enabled = true;
                spacing = mkLiteral "25px";
                padding = mkLiteral "50px";
                background-color = mkLiteral "transparent";
                children = map mkLiteral [
                  "inputbar"
                  "message"
                  "listview"
                  "mode-switcher"
                ];
              };

              "inputbar" = {
                enabled = true;
                spacing = mkLiteral "0px";
                margin = mkLiteral "0px 200px";
                padding = mkLiteral "5px";
                border = mkLiteral "1px solid";
                border-radius = mkLiteral "100%";
                border-color = mkLiteral "#3c3836"; # Gruvbox Dark Gray Border
                background-color = mkLiteral "transparent";
                children = map mkLiteral [
                  "textbox-prompt-colon"
                  "entry"
                ];
              };

              "textbox-prompt-colon" = {
                enabled = true;
                expand = false;
                padding = mkLiteral "8px 11px";
                border-radius = mkLiteral "100%";
                # CHANGED: Swapped Gruvbox Gold (#fabd2f) to Gruvbox Orange Focus (#fe8019)
                background-color = mkLiteral "#fe8019";
                text-color = mkLiteral "#000000"; # Dark Text on Accent
                str = "";
              };

              "entry" = {
                enabled = true;
                padding = mkLiteral "8px 12px";
                border = mkLiteral "0px solid";
                background-color = mkLiteral "transparent";
                text-color = mkLiteral "#fbf1c7"; # Gruvbox Cream Foreground
                cursor = mkLiteral "text";
                placeholder = "Search...";
                placeholder-color = mkLiteral "#7c6f64"; # Muted Gray Placeholder
                vertical-align = mkLiteral "0.5";
                horizontal-align = mkLiteral "0.0";
              };

              "listview" = {
                enabled = true;
                columns = 2;
                lines = 10;
                cycle = true;
                dynamic = true;
                scrollbar = false;
                layout = mkLiteral "vertical";
                reverse = false;
                fixed-height = true;
                fixed-columns = true;
                spacing = mkLiteral "10px";
                background-color = mkLiteral "transparent";
                cursor = "default";
              };

              "element" = {
                enabled = true;
                spacing = mkLiteral "10px";
                margin = mkLiteral "0px";
                padding = mkLiteral "5px";
                border = mkLiteral "0px solid";
                border-radius = mkLiteral "100%";
                border-color = mkLiteral "transparent";
                background-color = mkLiteral "transparent";
                text-color = mkLiteral "#fbf1c7";
                cursor = mkLiteral "pointer";
              };

              "element normal.normal" = {
                background-color = mkLiteral "transparent";
                text-color = mkLiteral "#fbf1c7";
              };

              "element normal.active" = {
                background-image = mkLiteral "linear-gradient(to right, #282828, #1d2021)";
                text-color = mkLiteral "#b8bb26"; # Gruvbox Green Accent
              };

              "element selected.normal" = {
                background-image = mkLiteral "linear-gradient(to right, #282828, #1d2021)"; # High-contrast OLED list cards
                text-color = mkLiteral "#fe8019"; # Gruvbox Orange Focus
              };

              "element selected.active" = {
                background-image = mkLiteral "linear-gradient(to right, #282828, #1d2021)";
                text-color = mkLiteral "#fb4934"; # Gruvbox Red Accent
              };

              "element-icon" = {
                background-color = mkLiteral "transparent";
                size = mkLiteral "24px";
                cursor = mkLiteral "inherit";
              };

              "element-text" = {
                background-color = mkLiteral "transparent";
                text-color = mkLiteral "inherit";
                cursor = mkLiteral "inherit";
                vertical-align = mkLiteral "0.5";
                horizontal-align = mkLiteral "0.0";
              };

              "mode-switcher" = {
                enabled = true;
                expand = false;
                spacing = mkLiteral "10px";
                margin = mkLiteral "0px 100px";
                padding = mkLiteral "12px";
                border-radius = mkLiteral "100%";
                background-color = mkLiteral "#1d2021"; # Gruvbox Background Accent Box
              };

              "button" = {
                background-color = mkLiteral "transparent";
                text-color = mkLiteral "#7c6f64";
                cursor = mkLiteral "pointer";
              };

              "button selected" = {
                background-color = mkLiteral "transparent";
                text-color = mkLiteral "#fe8019";
              };

              "error-message" = {
                padding = mkLiteral "20px";
                background-color = mkLiteral "#000000";
                text-color = mkLiteral "#fb4934";
              };

              "message" = {
                padding = mkLiteral "0px";
                background-color = mkLiteral "transparent";
                text-color = mkLiteral "#fe8019";
              };

              "textbox" = {
                padding = mkLiteral "0px";
                border-radius = mkLiteral "0px";
                background-color = mkLiteral "transparent";
                text-color = mkLiteral "inherit";
                vertical-align = mkLiteral "0.5";
                horizontal-align = mkLiteral "0.0";
              };
            };
        };
      }
    )
  ];
}
