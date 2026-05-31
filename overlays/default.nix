{ host, inputs, ... }:
let
  inherit (import ../hosts/${host}/variables.nix) sddmTheme;
in
{
  additions =
    final: _prev:
    import ../pkgs {
      pkgs = final;
      inherit host;
    };

  # https://wiki.nixos.org/wiki/Overlays
  modifications = final: prev: {
    nur = inputs.nur.overlay.default;
    stable = import inputs.nixpkgs-stable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };

    vscode = prev.vscode.override {
      commandLineArgs = "--password-store=\"gnome-libsecret\"";
    };

    # Override the default theme package to run its native yellow color tint option
    gruvbox-plus-icons = prev.gruvbox-plus-icons.overrideAttrs (oldAttrs: {
      postInstall = ''
        # Navigate inside the newly built share folder
        cd $out/share/icons/Gruvbox-Plus-Dark

        # Make the internal color switcher script executable
        patchShebangs preferences.sh

        # Run its native flag to swap out the default brown places assets to yellow (#fabd2f)
        ./preferences.sh --color yellow
      '';
    });
  };
}
