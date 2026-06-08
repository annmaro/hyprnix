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
        # Safely pull the themes/extensions directly from the flake packages
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      in
      {
        # Import the flake's module for your system
        imports = [ inputs.spicetify-nix.homeManagerModules.default ];

        # Force the local Nixpkgs instance evaluating this module to accept Spotify
        nixpkgs.config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "spotify"
            "spicetify"
          ];

        # Configure spicetify :)
        programs.spicetify = {
          enable = true;
          theme = spicePkgs.themes.catppuccin;
          colorScheme = "mocha";

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
