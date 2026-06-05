{ pkgs ? import <nixpkgs> {} }:
let
  stylix = import (fetchTarball "https://github.com/danth/stylix/archive/master.tar.gz");
in
pkgs.lib.evalModules {
  modules = [
    stylix.homeManagerModules.stylix
    {
      stylix.image = pkgs.fetchurl { url = "https://example.com/image.jpg"; sha256 = pkgs.lib.fakeSha256; };
      stylix.override = { base0D = "607d8b"; };
    }
  ];
}
