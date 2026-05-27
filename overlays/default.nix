{ host, inputs, ... }:
let
  inherit (import ../hosts/${host}/variables.nix) sddmTheme;
in
{
  # Overlay custom derivations into nixpkgs so you can use pkgs.<name>
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

    # Override the dank-material-shell package directly during compilation
    dank-material-shell = inputs.dms.packages.${final.stdenv.hostPlatform.system}.default.overrideAttrs (oldAttrs: {
      postPatch = (oldAttrs.postPatch or "") + ''
        # Locate BasePill.qml across the source layout and inject the blue border background style directly
        find . -name "BasePill.qml" -exec sed -i '/id: root/a \ \ \ \ \ \ \ \ Rectangle { anchors.fill: parent; color: dmsTheme.colors.surfaceContainer; radius: gothCornersEnabled ? gothCornerRadius : 12; border.width: 2; border.color: "#5895dc"; z: -1 }' {} +
      '';
    });

    # Override vscode for that annoying keyring warning in niri/hyprland 
    vscode = prev.vscode.override {
      commandLineArgs = "--password-store=\"gnome-libsecret\"";
    };

    # Override nomacs with our custom XWayland wrapper
    nomacs = prev.nomacs.overrideAttrs (old: {
      qtWrapperArgs = (old.qtWrapperArgs or []) ++ [
        "--set" "QT_QPA_PLATFORM" "xcb"
      ];
    });
  };
}