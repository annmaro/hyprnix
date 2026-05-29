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

    /*
      nomacs = prev.nomacs.overrideAttrs (old: {
        qtWrapperArgs = (old.qtWrapperArgs or []) ++ [
          "--set" "QT_QPA_PLATFORM" "xcb"
        ];
      });
    */
  };
}
