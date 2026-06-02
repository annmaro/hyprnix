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
        # 1. Create a custom pkgs instance that explicitly allows unfree packages
        unfreePkgs = import inputs.nixpkgs {
          inherit (pkgs) system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
        };

        # 2. Use spicetify-nix's internal builder to bind its packages to our unfreePkgs
        spicePkgs = inputs.spicetify-nix.builders.spicetify-packages {
          pkgs = unfreePkgs;
        };
      in
      {
        # import the flake's module for your system
        imports = [ inputs.spicetify-nix.homeManagerModules.default ];

        # configure spicetify :)
        programs.spicetify = {
          enable = true;

          # 3. Use the newly bound spicePkgs for both the theme and your extensions
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
