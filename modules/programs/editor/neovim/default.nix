# NVF is a Neovim configuration that provides a minimal setup with essential plugins and configurations.
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
    ./options.nix
    ./languages.nix
    ./picker.nix
    ./snacks.nix
    ./keymaps.nix
    ./utils.nix
    ./mini.nix
  ];
  home-manager.sharedModules = [
    (_: {

  programs.nvf = {
    enable = true;
    settings.vim = {
      startPlugins = [
        pkgs.vimPlugins.vim-kitty-navigator
      ];
    };
  };
 })
]; 
}
