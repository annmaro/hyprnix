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

    # Override the package derivation globally in nixpkgs
    dank-material-shell = inputs.dms.packages.${final.stdenv.hostPlatform.system}.default.overrideAttrs (oldAttrs: {
      postPatch = (oldAttrs.postPatch or "") + ''
        # Find BasePill.qml and insert the Rectangle style right below the ClickableRegion opening line
        find . -name "BasePill.qml" -exec sed -i '/ClickableRegion {/a \ \ \ \ Rectangle { anchors.fill: parent; color: dmsTheme.colors.surfaceContainer; radius: gothCornersEnabled ? gothCornerRadius : 12; border.width: 2; border.color: "#5895dc"; z: -1 }' {} +
      '';
    });

    vscode = prev.vscode.override {
      commandLineArgs = "--password-store=\"gnome-libsecret\"";
    };

    nomacs = prev.nomacs.overrideAttrs (old: {
      qtWrapperArgs = (old.qtWrapperArgs or []) ++ [
        "--set" "QT_QPA_PLATFORM" "xcb"
      ];
    });
  };
}