{ pkgs, ... }:

{
  # 🧩 Deploy the Custom System Logo Plugin
  home.file.".config/DankMaterialShell/plugins/custom-system-logo/customplugin.json".text =
    builtins.toJSON
      {
        id = "custom-system-logo";
        name = "Custom System Logo";
        type = "widget";
        component = "./CustomSystemLogo.qml";
      };

  # 🎨 Inline QML code directly inside Nix to avoid managing separate raw files
  home.file.".config/DankMaterialShell/plugins/custom-system-logo/CustomSystemLogo.qml".text = ''
    import QtQuick
    import QtQuick.Effects
    import Quickshell
    import Quickshell.Widgets
    import qs.Common
    import qs.Widgets

    Item {
        id: root

        property string colorOverride: ""
        property real brightnessOverride: 0.5
        property real contrastOverride: 1

        readonly property bool hasColorOverride: colorOverride !== ""

        # Instantly loaded NixOS Nerd Font config to prevent boot-vanishing bugs
        property bool useNerdFont: true
        property string nerdFontIcon: "nixos"

        IconImage {
            id: iconImage
            anchors.fill: parent
            visible: !root.useNerdFont

            smooth: true
            asynchronous: true
            layer.enabled: hasColorOverride

            layer.effect: MultiEffect {
                colorization: 1
                colorizationColor: colorOverride
                brightness: brightnessOverride
                contrast: contrastOverride
            }
        }

        DankNFIcon {
            id: nfIcon
            anchors.centerIn: parent
            visible: root.useNerdFont
            name: root.nerdFontIcon
            size: Math.min(root.width, root.height)
            color: hasColorOverride ? colorOverride : Theme.surfaceText
        }
    }
  '';
}
