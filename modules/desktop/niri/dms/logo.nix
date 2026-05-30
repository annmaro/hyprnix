{ pkgs, ... }:

{
  # Force Home Manager to write the entire custom-system-logo directory directly
  xdg.configFile."DankMaterialShell/plugins/custom-system-logo/customplugin.json".text =
    builtins.toJSON
      {
        id = "custom-system-logo";
        name = "Custom System Logo";
        type = "widget";
        component = "CustomSystemLogo.qml";
      };

  xdg.configFile."DankMaterialShell/plugins/custom-system-logo/CustomSystemLogo.qml".text = ''
    import QtQuick
    import QtQuick.Layouts
    import QtQuick.Effects
    import Quickshell
    import Quickshell.Widgets
    import qs.Common
    import qs.Widgets

    Item {
        id: root
        
        implicitWidth: Theme.barHeight || 32
        implicitHeight: Theme.barHeight || 32
        
        property var permanentRef: [iconImage, nfIcon]

        property string colorOverride: ""
        property real brightnessOverride: 0.5
        property real contrastOverride: 1
        readonly property bool hasColorOverride: colorOverride !== ""

        property bool useNerdFont: true
        property string nerdFontIcon: "nixos"

        IconImage {
            id: iconImage
            anchors.fill: parent
            visible: !root.useNerdFont
            smooth: true
            asynchronous: false
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
            size: Math.min(root.width, root.height) * 0.8
            color: hasColorOverride ? colorOverride : Theme.surfaceText
        }
    }
  '';
}
