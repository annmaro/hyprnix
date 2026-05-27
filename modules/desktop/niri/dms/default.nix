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
      };
        
      # =====================================================================
      # 🎨 CUSTOM QML WIDGET OVERRIDES (Borders & Corner Radii)
      # =====================================================================
       
      # Global BasePill Override (Catches Weather, CPU, Control Center, etc.)
      xdg.configFile."quickshell/dms/quickshell/Widgets/BasePill.qml".text = ''
        import QtQuick
        import Quickshell
        import qs.Common
        import qs.Modules.Plugins

        // We extend the native mouse-interactive surface base item 
        ClickableRegion {
            id: root

            property alias content: contentLoader.sourceComponent
            property bool isVerticalOrientation: barConfig ? barConfig.position === "left" || barConfig.position === "right" : false
            property real widgetThickness: barConfig ? barConfig.height : 48
            property real horizontalPadding: 12

            // Styled border container acting as the background template for all modules
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

      programs.dank-material-shell.modules = {
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
      programs.dank-material-shell.theme = "catppuccin-macchiato"; 
      programs.dank-material-shell.dynamicTheming = false;      

      programs.dank-material-shell.weatherEnabled = true;
      programs.dank-material-shell.weatherLocation = "Ramgarh, Jharkhand, India";
      programs.dank-material-shell.weatherCoordinates = "23.5987759,85.5369156";
      programs.dank-material-shell.useFahrenheit = false;
      programs.dank-material-shell.useLocation = false;

      programs.dank-material-shell.barConfigs = [
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
      programs.dank-material-shell.widgets = {
        workspace_switcher = {
          show_labels = false;
          indicator_style = "pill";
        };
      };
    })
  ];
}