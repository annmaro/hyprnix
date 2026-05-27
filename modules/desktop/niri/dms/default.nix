{ config, pkgs, lib, inputs, ... }:

{
  home-manager.sharedModules = [
    (_: { 
      imports = [
        inputs.dms.homeModules.dank-material-shell
        inputs.dms.homeModules.niri # Enforce native Niri features & auto-spawning
      ];

      programs.dank-material-shell = {
        enable = true;
        systemd.enable = true; 
 
        niri = {
          enableKeybinds = false; # Disable DMS's built-in keybinds to prevent conflicts with your custom ones
          enableSpawn = false;   # Disable DMS's built-in autostart to prevent conflicts with your custom spawn-at-startup setup
        };
      };

      # Forces DMS to scale up fonts and icons nicely together
      systemd.user.services.dms = {
        Service = {
          Environment = [
            "QT_SCALE_FACTOR=1.3" # 1.3 = 130% size. Adjust this up or down as needed!
          ];
        };
      };

      home.packages = with pkgs; [
        dgop # Required for DMS system tracking features
        nerd-fonts.jetbrains-mono
        material-symbols
        material-design-icons
      ];

      xdg.configFile."DankMaterialShell/settings.json".text = builtins.toJSON {
        configVersion = 2;
        disableWallpaper = false; # Set true if you want to handle wallpaper through swaybg/awww
        
       # =====================================================================
      # 🎨 CUSTOM QML WIDGET OVERRIDES (Borders & Corner Radii)
      # =====================================================================
       
      # 1. Global BasePill Override (Catches Weather, CPU, Control Center, etc.)
      xdg.configFile."quickshell/dms/quickshell/Widgets/BasePill.qml".text = ''
      import QtQuick
import Quickshell
import qs.Common
import qs.Modules.Plugins
import qs.Widgets

BasePill {
    id: root

    property var widgetData: null
    property bool compactMode: false
    signal clockClicked

    onClicked: clockClicked()

    // Global variables to ensure all modules share the exact same styling
    readonly property color customBorderColor: "#5895dc"
    readonly property int customBorderWidth: 2
    readonly property int customRadius: gothCornersEnabled ? gothCornerRadius : 12

    // --- 1. CLOCK BACKGROUND ---
    Rectangle {
        id: clockBackground
        anchors.fill: parent
        color: dmsTheme.colors.surfaceContainer
        radius: root.customRadius
        border.width: root.customBorderWidth
        border.color: root.customBorderColor
        z: -1
    }

    // --- 2. WEATHER BACKGROUND ---
    Rectangle {
        id: weatherBackground
        visible: !!root.widgetData?.showWeather
        anchors.fill: parent
        color: dmsTheme.colors.surfaceContainer
        radius: root.customRadius
        border.width: root.customBorderWidth
        border.color: root.customBorderColor
        z: -1
    }

    // --- 3. NOTIFICATIONS BACKGROUND ---
    Rectangle {
        id: notificationsBackground
        visible: !!root.widgetData?.showNotifications
        anchors.fill: parent
        color: dmsTheme.colors.surfaceContainer
        radius: root.customRadius
        border.width: root.customBorderWidth
        border.color: root.customBorderColor
        z: -1
    }

    // --- 4. NETWORK SPEED BACKGROUND ---
    Rectangle {
        id: networkSpeedBackground
        visible: !!root.widgetData?.showNetworkSpeed
        anchors.fill: parent
        color: dmsTheme.colors.surfaceContainer
        radius: root.customRadius
        border.width: root.customBorderWidth
        border.color: root.customBorderColor
        z: -1
    }

    // --- 5. GPU TEMP BACKGROUND ---
    Rectangle {
        id: gpuTempBackground
        visible: !!root.widgetData?.showGpuTemp
        anchors.fill: parent
        color: dmsTheme.colors.surfaceContainer
        radius: root.customRadius
        border.width: root.customBorderWidth
        border.color: root.customBorderColor
        z: -1
    }

    // --- 6. CONTROL CENTER BACKGROUND ---
    Rectangle {
        id: controlCenterBackground
        visible: !!root.widgetData?.showControlCenter
        anchors.fill: parent
        color: dmsTheme.colors.surfaceContainer
        radius: root.customRadius
        border.width: root.customBorderWidth
        border.color: root.customBorderColor
        z: -1
    }

    // --- 7. CPU USAGE BACKGROUND ---
    Rectangle {
        id: cpuUsageBackground
        visible: !!root.widgetData?.showCpuUsage
        anchors.fill: parent
        color: dmsTheme.colors.surfaceContainer
        radius: root.customRadius
        border.width: root.customBorderWidth
        border.color: root.customBorderColor
        z: -1
    }

    content: Component {
        Item {
            implicitWidth: root.isVerticalOrientation ?
                (root.widgetThickness - root.horizontalPadding * 2) : clockRow.implicitWidth
            implicitHeight: root.isVerticalOrientation ?
                clockColumn.implicitHeight : (root.widgetThickness - root.horizontalPadding * 2)

            readonly property bool compact: widgetData?.clockCompactMode !== undefined ?
                widgetData.clockCompactMode : SettingsData.clockCompactMode

            Column {
                id: clockColumn
                visible: root.isVerticalOrientation
                anchors.centerIn: parent
                spacing: 0

                Row {
                    spacing: 0
                    anchors.horizontalCenter: parent.horizontalCenter

                    StyledText {
                        text: {
                            const hours = systemClock?.date?.getHours();
                            if (SettingsData.use24HourClock)
                                return String(hours).padStart(2, '0').charAt(0);
                            const display = hours === 0 ? 12 : hours > 12 ? hours - 12 : hours;
                            return String(display).padStart(2, '0').charAt(0);
                        }
                        font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                        color: Theme.widgetTextColor
                        width: Math.round(font.pixelSize * 0.6)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom
                    }

                    StyledText {
                        text: {
                            const hours = systemClock?.date?.getHours();
                            if (SettingsData.use24HourClock)
                                return String(hours).padStart(2, '0').charAt(1);
                            const display = hours === 0 ? 12 : hours > 12 ? hours - 12 : hours;
                            return String(display).padStart(2, '0').charAt(1);
                        }
                        font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                        color: Theme.widgetTextColor
                        width: Math.round(font.pixelSize * 0.6)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom
                    }
                }

                Row {
                    spacing: 0
                    anchors.horizontalCenter: parent.horizontalCenter

                    StyledText {
                        text: String(systemClock?.date?.getMinutes()).padStart(2, '0').charAt(0)
                        font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                        color: Theme.widgetTextColor
                        width: Math.round(font.pixelSize * 0.6)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom
                    }

                    StyledText {
                        text: String(systemClock?.date?.getMinutes()).padStart(2, '0').charAt(1)
                        font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                        color: Theme.widgetTextColor
                        width: Math.round(font.pixelSize * 0.6)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom
                    }
                }

                Row {
                    visible: SettingsData.showSeconds
                    spacing: 0
                    anchors.horizontalCenter: parent.horizontalCenter

                    StyledText {
                        text: String(systemClock?.date?.getSeconds()).padStart(2, '0').charAt(0)
                        font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                        color: Theme.widgetTextColor
                        width: Math.round(font.pixelSize * 0.6)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom
                    }

                    StyledText {
                        text: String(systemClock?.date?.getSeconds()).padStart(2, '0').charAt(1)
                        font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                        color: Theme.widgetTextColor
                        width: Math.round(font.pixelSize * 0.6)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom
                    }
                }

                Item {
                    width: parent.width
                    height: Theme.spacingM
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: !compact

                    Rectangle {
                        width: parent.width * 0.6
                        height: 1
                        color: Theme.outlineButton
                        anchors.centerIn: parent
                    }
                }

                Row {
                    spacing: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: !compact

                    StyledText {
                        text: {
                            const locale = I18n.locale();
                            const dateFormatShort = locale.dateFormat(Locale.ShortFormat);
                            const dayFirst = dateFormatShort.indexOf('d') < dateFormatShort.indexOf('M');
                            const value = dayFirst ?
                                String(systemClock?.date?.getDate()).padStart(2, '0') : String(systemClock?.date?.getMonth() + 1).padStart(2, '0');
                            return value.charAt(0);
                        }
                        font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                        color: Theme.primary
                        width: Math.round(font.pixelSize * 0.6)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom
                    }

                    StyledText {
                        text: {
                            const locale = I18n.locale();
                            const dateFormatShort = locale.dateFormat(Locale.ShortFormat);
                            const dayFirst = dateFormatShort.indexOf('d') < dateFormatShort.indexOf('M');
                            const value = dayFirst ?
                                String(systemClock?.date?.getDate()).padStart(2, '0') : String(systemClock?.date?.getMonth() + 1).padStart(2, '0');
                            return value.charAt(1);
                        }
                        font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                        color: Theme.primary
                        width: Math.round(font.pixelSize * 0.6)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom
                    }
                }

                Row {
                    spacing: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: !compact

                    StyledText {
                        text: {
                            const locale = I18n.locale();
                            const dateFormatShort = locale.dateFormat(Locale.ShortFormat);
                            const dayFirst = dateFormatShort.indexOf('d') < dateFormatShort.indexOf('M');
                            const value = dayFirst ?
                                String(systemClock?.date?.getMonth() + 1).padStart(2, '0') : String(systemClock?.date?.getDate()).padStart(2, '0');
                            return value.charAt(0);
                        }
                        font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                        color: Theme.primary
                        width: Math.round(font.pixelSize * 0.6)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom
                    }

                    StyledText {
                        text: {
                            const locale = I18n.locale();
                            const dateFormatShort = locale.dateFormat(Locale.ShortFormat);
                            const dayFirst = dateFormatShort.indexOf('d') < dateFormatShort.indexOf('M');
                            const value = dayFirst ?
                                String(systemClock?.date?.getMonth() + 1).padStart(2, '0') : String(systemClock?.date?.getDate()).padStart(2, '0');
                            return value.charAt(1);
                        }
                        font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                        color: Theme.primary
                        width: Math.round(font.pixelSize * 0.6)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom
                    }
                }
            }

            Row {
                id: clockRow
                visible: !root.isVerticalOrientation
                anchors.centerIn: parent
                spacing: Theme.spacingS

                property real fontSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                property real digitWidth: fontSize * 0.6

                property string hoursStr: {
                    const hours = systemClock?.date?.getHours() ?? 0;
                    if (SettingsData.use24HourClock)
                        return String(hours).padStart(2, '0');
                    const display = hours === 0 ? 12 : hours > 12 ? hours - 12 : hours;
                    if (SettingsData.padHours12Hour)
                        return String(display).padStart(2, '0');
                    return String(display);
                }
                property string minutesStr: String(systemClock?.date?.getMinutes() ?? 0).padStart(2, '0')
                property string secondsStr: String(systemClock?.date?.getSeconds() ?? 0).padStart(2, '0')
                property string ampmStr: {
                    if (SettingsData.use24HourClock)
                        return "";
                    const hours = systemClock?.date?.getHours() ?? 0;
                    return hours >= 12 ? " PM" : " AM";
                }

                Row {
                    spacing: 0
                    anchors.verticalCenter: parent.verticalCenter

                    StyledText {
                        visible: clockRow.hoursStr.length > 1
                        text: clockRow.hoursStr.charAt(0)
                        font.pixelSize: clockRow.fontSize
                        color: Theme.widgetTextColor
                        width: clockRow.digitWidth
                        horizontalAlignment: Text.AlignHCenter
                    }

                    StyledText {
                        text: clockRow.hoursStr.length > 1 ? clockRow.hoursStr.charAt(1) : clockRow.hoursStr.charAt(0)
                        font.pixelSize: clockRow.fontSize
                        color: Theme.widgetTextColor
                        width: clockRow.digitWidth
                        horizontalAlignment: Text.AlignHCenter
                    }

                    StyledText {
                        text: ":"
                        font.pixelSize: clockRow.fontSize
                        color: Theme.widgetTextColor
                    }

                    StyledText {
                        text: clockRow.minutesStr.charAt(0)
                        font.pixelSize: clockRow.fontSize
                        color: Theme.widgetTextColor
                        width: clockRow.digitWidth
                        horizontalAlignment: Text.AlignHCenter
                    }

                    StyledText {
                        text: clockRow.minutesStr.charAt(1)
                        font.pixelSize: clockRow.fontSize
                        color: Theme.widgetTextColor
                        width: clockRow.digitWidth
                        horizontalAlignment: Text.AlignHCenter
                    }

                    StyledText {
                        visible: SettingsData.showSeconds
                        text: ":"
                        font.pixelSize: clockRow.fontSize
                        color: Theme.widgetTextColor
                    }

                    StyledText {
                        visible: SettingsData.showSeconds
                        text: clockRow.secondsStr.charAt(0)
                        font.pixelSize: clockRow.fontSize
                        color: Theme.widgetTextColor
                        width: clockRow.digitWidth
                        horizontalAlignment: Text.AlignHCenter
                    }

                    StyledText {
                        visible: SettingsData.showSeconds
                        text: clockRow.secondsStr.charAt(1)
                        font.pixelSize: clockRow.fontSize
                        color: Theme.widgetTextColor
                        width: clockRow.digitWidth
                        horizontalAlignment: Text.AlignHCenter
                    }

                    StyledText {
                        visible: !SettingsData.use24HourClock
                        text: clockRow.ampmStr
                        font.pixelSize: clockRow.fontSize
                        color: Theme.widgetTextColor
                    }
                }

                StyledText {
                    id: middleDot
                    text: "•"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.outlineButton
                    anchors.verticalCenter: parent.verticalCenter
                    visible: !compact
                }

                StyledText {
                    id: dateText
                    text: {
                        if (SettingsData.clockDateFormat && SettingsData.clockDateFormat.length > 0) {
                            return systemClock?.date?.toLocaleDateString(I18n.locale(), SettingsData.clockDateFormat);
                        }
                        return systemClock?.date?.toLocaleDateString(I18n.locale(), "ddd d");
                    }
                    font.pixelSize: clockRow.fontSize
                    color: Theme.widgetTextColor
                    anchors.verticalCenter: parent.verticalCenter
                    visible: !compact
                }
            }

            SystemClock {
                id: systemClock
                precision: SettingsData.showSeconds ? SystemClock.Seconds : SystemClock.Minutes
            }
        }
    }
}
'';  

        modules = {
          bar = true;
          notifications = true;
          idle = true;          
          lockscreen = true;    
          wallpaper = true; # false to keep it managed by your separate awww/swaybg
          launcher = false;  # Handled by your native rofi setup
          dock = false;         
        };

        # ==========================================
        # 📊 BAR INTERFACE & SIZING CONFIGURATION
        # ==========================================
        theme = "catppuccin-macchiato"; 
        dynamicTheming = false;      

    
        weatherEnabled = true;
        weatherLocation = "Ramgarh, Jharkhand, India";
        weatherCoordinates = "23.5987759,85.5369156";
        useFahrenheit = false;
        useLocation = false;

        barConfigs = [
          {
            id = "default";
            name = "Main Bar";
            enabled = true;
            position = "top";
            floating = true; # Enable floating to allow for custom margins and independent styling  
            margin = 8;            
            height = 48;           
            borderRadius = 12;
            
            # Setting bar transparency to 0 hides the background bar, 
            # allowing only the styled widgets to display as floating pill capsules.
            transparency = 0.01;    
            widgetTransparency = 0.90; 
            
            network_click_action = "applet";
            audio_click_action = "applet";

            leftWidgets = [
              "workspaceSwitcher"  
              "focusedWindow"      
            ];
            centerWidgets = [
              "clock"              
            ];
            rightWidgets = [
              "weather"
              "systemTray"         
              "cpuUsage"           
              "memUsage"
              "controlCenterButton" 
            ];
          }
        ];

        # The exact config to hide workspace labels across Dank Material Shell
        widgets = {
          workspace_switcher = {
            show_labels = false;
            indicator_style = "pill";
          };
        };
      };
    })
  ];
}



