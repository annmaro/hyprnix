{ pkgs, ... }:

{
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

    # Changing the root to a Layout item hooks directly into the bar layout pipeline,
    # preventing Quickshell from garbage collecting it as an orphan object.
    RowLayout {
        id: root
        
        spacing: 0
        Layout.fillWidth: false
        Layout.fillHeight: true
        
        implicitWidth: Theme.barHeight || 32
        implicitHeight: Theme.barHeight || 32

        property string colorOverride: ""
        property real brightnessOverride: 0.5
        property real contrastOverride: 1
        readonly property bool hasColorOverride: colorOverride !== ""

        property bool useNerdFont: true
        property string nerdFontIcon: "nixos"

        # Explicit container wrapper to hold object allocation in memory scope
        Item {
            id: container
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            implicitWidth: root.implicitWidth
            implicitHeight: root.implicitHeight

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
                size: Math.min(parent.width, parent.height) * 0.8
                color: hasColorOverride ? colorOverride : Theme.surfaceText
            }
        }
    }
  '';
}
