{
  inputs,
  lib,
  ...
}:
{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      let
        # 1. Grab the theme packages from the input normally
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};

        # 2. Build a local unfree package set just for pulling the core spotify binary
        unfreePkgs = import inputs.nixpkgs {
          inherit (pkgs) system;
          config.allowUnfree = true;
        };
      in
      {
        # import the flake's module for your system
        imports = [ inputs.spicetify-nix.homeManagerModules.default ];

        # configure spicetify :)
        programs.spicetify = {
          enable = true;

          # 3. Force the module to build the final client using our unfree package set
          spicetifyPackage = spicePkgs.spicetify.override { pkgs = unfreePkgs; };

          theme = spicePkgs.themes.onepunch;
          colorScheme = "dark";

          enabledExtensions = with spicePkgs.extensions; [
            adblock
            shuffle
            keyboardShortcut
            copyLyrics
          ];
        };
      }
    )
  ];
}
