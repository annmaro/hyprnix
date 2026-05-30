{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.yazi = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        shellWrapperName = "y";

        # 1. DECLARE THE GVFS PLUGIN HERE
        plugins = {
          gvfs = pkgs.yaziPlugins.gvfs;
        };

        settings = {
          manager = {
            show_hidden = true;
            show_symlink = true;
            sort_dir_first = true;
            linemode = "size";
            ratio = [
              1
              3
              4
            ];
          };
          preview = {
            tab_size = 4;
            image_filter = "triangle";
            max_width = 1920;
            max_height = 1080;
            image_quality = 90;
          };
        };

        keymap = {
          manager.prepend_keymap = [
            {
              on = [ "e" ];
              run = "open";
            }
            {
              on = [ "d" ];
              run = "remove --force";
            }

            # 2. ADD THE GVFS MOUNTING AND JUMP KEYBINDS HERE
            {
              on = [
                "M"
                "m"
              ];
              run = "plugin gvfs -- select-then-mount --jump";
              desc = "Select device to mount and jump to its path";
            }
            {
              on = [
                "M"
                "u"
              ];
              run = "plugin gvfs -- unmount-current-cwd-device";
              desc = "Unmount current device";
            }
          ];
        };

        # MERGED AND UPDATED THEME BLOCK
        theme = {
          flavor = {
            use = "gruvbox-dark";
          };
          manager = {
            border_symbol = " ";
          };
          status = {
            separator_open = "";
            separator_close = "";
          };
          # This overrides the folder colors from the base flavor
          filetype = [
            {
              name = "*/";
              fg = "#fabd2f";
            } # Targets directory names/icons
          ];
        };
      };
    })
  ];
}
