{ config, lib, ... }:
{
  programs.nvf.settings.vim = {
    viAlias = false;
    vimAlias = true;
    withNodeJs = true;
    # syntaxHighlighting = true;
    options = {
      autoindent = true;
      smartindent = true;
      shiftwidth = 2;
      foldlevel = 99;
      foldcolumn = "auto:1";
      mousescroll = "ver:1,hor:1";
      mousemoveevent = true;
      fillchars = "eob:‿,fold: ,foldopen:▼,foldsep:⸽,foldclose:⏵";
      signcolumn = "yes";
      tabstop = 2;
      softtabstop = 2;
      wrap = false;
    };
    globals = {
      navic_silence = true;
      suda_smart_edit = 1;
      neovide_scale_factor = 0.7;
      neovide_cursor_animation_length = 0.1;
      neovide_cursor_short_animation_length = 0;
    };
    clipboard = {
      enable = true;
      registers = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    # Updated to dynamically pull colors from your Stylix system variables
    theme = {
      enable = true;
      name = "base16"; # Switches nvf to look at standard base16 palette configurations
      style = "dark";
      transparent = lib.mkForce true;

      # Feeds the dynamic Stylix Base16 table straight into the nvf compiler engine
      base16-colors = {
        base00 = "${config.lib.stylix.colors.base00}";
        base01 = "${config.lib.stylix.colors.base01}";
        base02 = "${config.lib.stylix.colors.base02}";
        base03 = "${config.lib.stylix.colors.base03}";
        base04 = "${config.lib.stylix.colors.base04}";
        base05 = "${config.lib.stylix.colors.base05}";
        base06 = "${config.lib.stylix.colors.base06}";
        base07 = "${config.lib.stylix.colors.base07}";
        base08 = "${config.lib.stylix.colors.base08}";
        base09 = "${config.lib.stylix.colors.base09}";
        base0A = "${config.lib.stylix.colors.base0A}";
        base0B = "${config.lib.stylix.colors.base0B}";
        base0C = "${config.lib.stylix.colors.base0C}";
        base0D = "${config.lib.stylix.colors.base0D}";
        base0E = "${config.lib.stylix.colors.base0E}";
        base0F = "${config.lib.stylix.colors.base0F}";
      };
    };
  };
}
