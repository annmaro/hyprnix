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

    # Use NVF's native catppuccin theme to match Stylix without relying on the crash-prone base16 plugin
    theme = {
      enable = true;
      name = lib.mkForce "catppuccin";
      style = lib.mkForce "mocha";
      transparent = lib.mkForce true;
    };
  };
}
