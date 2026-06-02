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
        # Import spicetify-nix's pin of nixpkgs and inject the allowUnfree config
        spicePkgs = import inputs.spicetify-nix.inputs.nixpkgs {
          inherit (pkgs) system;
          config = {
            allowUnfree = true;
          };
        };
      in
      {
        # import the flake's module for your system
        imports = [ inputs.spicetify-nix.homeManagerModules.default ];

        # configure spicetify :)
        programs.spicetify = {
          enable = true;
          theme = inputs.spicetify-nix.legacyPackages.${pkgs.system}.themes.onepunch;
          colorScheme = "dark";
          # windowManagerPatch = config.programs.hyprland.enable;
          enabledExtensions = with spicePkgs.extensions; [
            adblock
            shuffle # shuffle+ (special characters are sanitized out of ext names)
            keyboardShortcut # vimium-like navigation
            copyLyrics # copy lyrics with selection
            # autoVolume
            # showQueueDuration
            # fullAppDisplay
            # hidePodcasts
          ];
          # enabledCustomApps = with spicePkgs.apps; [
          #   reddit
          #   lyricsPlus
          #   marketplace
          #   localFiles
          #   ncsVisualizer
          # ];
        };
      }
    )
  ];
}
