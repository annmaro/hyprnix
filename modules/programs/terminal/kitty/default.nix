{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      /* Optional Pointer Theme Override if you want your cursor to match the Gruvbox yellow accents */
      home.pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic"; 
        size = 24;
        gtk.enable = true;
        x11.enable = true;
      };

      programs.kitty = {
        enable = true;
        font = {
          size = 14.0;
          name = "JetBrainsMono Nerd Font";
        };
        
        /* Drop themeFile to allow full custom AMOLED injection without upstream errors */
        settings = {
          # shell = "${getExe pkgs.tmux}";
          # cursor_trail = 3; # Fancy cursor movements (especially in nixvim)
          # cursor_trail_decay = "0.08 0.3"; # Animation speed
          # cursor_trail_start_threshold = "4";
          strip_trailing_spaces = "smart";
          macos_option_as_alt = "yes";
          macos_quit_when_last_window_closed = true;
          copy_on_select = "yes";
          confirm_os_window_close = 0;
          scrollback_lines = 10000;
          enable_audio_bell = false;
          mouse_hide_wait = 60;
          update_check_interval = 0;

          ## Tabs
          tab_title_template = "{index}";
          active_tab_font_style = "normal";
          inactive_tab_font_style = "normal";
          tab_bar_style = "powerline";
          tab_powerline_style = "round";
          
          /* Gruvbox AMOLED Tab Mapping */
          active_tab_foreground = "#000000";   /* Absolute Pitch Black Text */
          active_tab_background = "#fabd2f";   /* Gruvbox Bright Yellow Active Accent */
          inactive_tab_foreground = "#a89983"; /* Gruvbox Muted Gray Text */
          inactive_tab_background = "#1d2021"; /* Dark Charcoal Accent Background */

          ## Core Palette Overrides (AMOLED Black)
          background            = "#000000";   /* Deep OLED Pixel-Off Pitch Black */
          foreground            = "#fbf1c7";   /* Gruvbox Cream Foreground */
          cursor                = "#fabd2f";   /* Gruvbox Yellow/Gold Terminal Cursor */
          selection_background  = "#282828";
          selection_foreground  = "#fbf1c7";

          /* Normal Colors */
          color0  = "#000000"; /* Black */
          color1  = "#fb4934"; /* Red */
          color2  = "#b8bb26"; /* Green */
          color3  = "#fabd2f"; /* Yellow */
          color4  = "#83a598"; /* Blue */
          color5  = "#d3869b"; /* Magenta */
          color6  = "#8ec07c"; /* Cyan */
          color7  = "#a89983"; /* White */

          /* Bright Colors */
          color8  = "#665c54"; /* Bright Black */
          color9  = "#fb4934"; /* Bright Red */
          color10 = "#b8bb26"; /* Bright Green */
          color11 = "#fabd2f"; /* Bright Yellow */
          color12 = "#83a598"; /* Bright Blue */
          color13 = "#d3869b"; /* Bright Magenta */
          color14 = "#8ec07c"; /* Bright Cyan */
          color15 = "#fbf1c7"; /* Bright White */
        };
        # shellIntegration.mode = "no-sudo";
        keybindings = {
          "ctrl+alt+n" = "launch --cwd=current";
          "alt+w" = "copy_and_clear_or_interrupt";
          "ctrl+y" = "paste_from_clipboard";
          "alt+1" = "goto_tab 1";
          "alt+2" = "goto_tab 2";
          "alt+3" = "goto_tab 3";
          "alt+4" = "goto_tab 4";
          "alt+5" = "goto_tab 5";
          "alt+6" = "goto_tab 6";
          "alt+7" = "goto_tab 7";
          "alt+8" = "goto_tab 8";
          "alt+9" = "goto_tab 9";
          "alt+0" = "goto_tab 10";

          # Tmux
          "ctrl+t" = "launch --cwd=current --type=overlay tmux-sessionizer";
          # "ctrl+t" = "launch --cwd=current --title tmux-sessionizer tmux-sessionizer";
          "ctrl+shift+left" = "no_op";
          "ctrl+shift+right" = "no_op";
        };
      };
    })
  ];
}