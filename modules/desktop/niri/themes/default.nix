{ pkgs, ... }:

{
  imports = [
    ./gtk.nix
    ./qt.nix
  ];
}