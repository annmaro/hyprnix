{ pkgs, ... }:

{
  # 🧩 Deploy the Custom System Logo Plugin
  home.file.".config/DankMaterialShell/plugins/custom-system-logo/customplugin.json".text =
    builtins.toJSON
      {
        id = "custom-system-logo";
        name = "Custom System Logo";
        type = "widget";
        component = "CustomSystemLogo.qml";
      };

  # 🎨 Inline QML code with explicit lifetime persistence bindings
  home.file.".config/DankMaterialShell/plugins/custom-system-logo/CustomSystemLogo.qml".text = ''
    import QtQuick
    import QtQuick.Layouts
    import QtQuick.Effects
    import Quickshell
    import Quickshell.Widgets
    import qs.Common
    import qs.Widgets

    # Wrapping in a Layout Item forces the engine's garbage collection to retain the object lifecycle
    Item {
        id: root
        
        # Explicitly declare structural sizing boundaries so the widget maintains a permanent footprint
        implicitWidth: Theme.barHeight || 32
        implicitHeight: Theme.barHeight || 32
        
        # Keep the memory references explicitly tied to the root component's structural tree
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
            asynchronous: false  # Changed to false to prevent asynchronous unloading cycles
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
            size: Math.min(root.width, root.height) * 0.8  # Slight scaling pad to match other icons perfectly
            color: hasColorOverride ? colorOverride : Theme.surfaceText
        }
    }
  '';
}
