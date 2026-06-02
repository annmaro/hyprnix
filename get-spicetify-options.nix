let
  flake = builtins.getFlake "github:Gerg-L/spicetify-nix/c679f3fa9fbe86903486a8f7ad71f99e26481d71";
  lib = (builtins.getFlake "nixpkgs").lib;
  hmModule = flake.homeManagerModules.default;
  eval = lib.evalModules {
    modules = [
      hmModule
      {
        options.home.homeDirectory = lib.mkOption { default = "/home/test"; };
        options.home.username = lib.mkOption { default = "test"; };
      }
    ];
    specialArgs = {
      pkgs = import (builtins.getFlake "nixpkgs") { system = "x86_64-linux"; };
    };
  };
in
builtins.attrNames eval.options.programs.spicetify
