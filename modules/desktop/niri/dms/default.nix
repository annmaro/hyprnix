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

      # =====================================================================
      # 🎨 SETTINGS.JSON CONFIGURATION
      # =====================================================================
      xdg.configFile."DankMaterialShell/settings.json".text = builtins.toJSON {
        configVersion = 2;
        disableWallpaper = false; # Set true if you want to handle wallpaper through swaybg/awww
        
        modules = {
          bar = true;
          notifications = true;
          idle = true;          
          lockscreen = true;    
          wallpaper = true; # false to keep it managed by your separate awww/swaybg
          launcher = false;  # Handled by your native rofi setup
          dock = false;         
        };

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

        widgets = {
          workspace_switcher = {
            show_labels = false;
            indicator_style = "pill";
          };
        };
      };
        
      # =====================================================================
      # 🎨 CUSTOM QML WIDGET OVERRIDES (Borders & Corner Radii)
      # =====================================================================
      xdg.configFile."quickshell/dms/quickshell/Widgets/BasePill.qml".text = ''
        import QtQuick
        import Quickshell
        import qs.Common
        import qs.Modules.Plugins

        ClickableRegion {
            id: root

            property alias content: contentLoader.sourceComponent
            property bool isVerticalOrientation: barConfig ? barConfig.position === "left" || barConfig.position === "right" : false
            property real widgetThickness: barConfig ? barConfig.height : 48
            property real horizontalPadding: 12

            Rectangle {
                id: widgetBackground
                anchors.fill: parent
                color: dmsTheme.colors.surfaceContainer
                radius: gothCornersEnabled ? gothCornerRadius : 12
                border.width: 2
                border.color: "#5895dc"
                z: -1
            }

            Loader {
                id: contentLoader
                anchors.fill: parent
                anchors.leftMargin: root.horizontalPadding
                anchors.rightMargin: root.horizontalPadding
            }
        }
      '';  
    })
  ];
}