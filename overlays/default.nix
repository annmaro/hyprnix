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

    # =====================================================================
    # 🛠️ DANK MATERIAL SHELL QML PATCH OVERRIDE
    # =====================================================================
    dank-material-shell = inputs.dms.packages.${final.stdenv.hostPlatform.system}.default.overrideAttrs (oldAttrs: {
      postPatch = (oldAttrs.postPatch or "") + ''
        # Use find and sed to locate and inject border properties safely.
        
        # 1. Patch the Clock widget background
        if [ -f quickshell/Modules/DankBar/Widgets/Clock.qml ]; then
          substituteInPlace quickshell/Modules/DankBar/Widgets/Clock.qml \
            --replace "radius: gothCornersEnabled ? gothCornerRadius : 12" \
                      "radius: gothCornersEnabled ? gothCornerRadius : 12; border.width: 2; border.color: \"#5895dc\""
        fi

        # 2. Patch the Workspace Switcher background
        if [ -f quickshell/Modules/DankBar/Widgets/WorkspaceSwitcher.qml ]; then
          substituteInPlace quickshell/Modules/DankBar/Widgets/WorkspaceSwitcher.qml \
            --replace "radius: gothCornersEnabled ? gothCornerRadius : 12" \
                      "radius: gothCornersEnabled ? gothCornerRadius : 12; border.width: 2; border.color: \"#5895dc\""
        fi
      '';
    });
  };
}