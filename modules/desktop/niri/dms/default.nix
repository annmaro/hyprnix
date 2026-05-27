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

      # Set interface scaling cleanly
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
            
            # Setting bar transparency to 0 hides the background bar background, 
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
      # 🔮 QUICKSHELL DESKTOP ENGINE INTERCEPT ROUTINE
      # =====================================================================
      # This completely bypasses file-path replacement issues by intercepting Quickshell's 
      # global entrypoint window. It runs the stock DMS bar, but forces an absolute border 
      # overlay over the widget layer layout containers dynamically.
      xdg.configFile."quickshell/root.qml".text = ''
        import QtQuick
        import Quickshell
        import "./dms/quickshell" as DMSEntry

        Scope {
            id: rootScope

            // Instantiate the complete DankMaterialShell stock environment
            DMSEntry.root {
                id: dmsInstance
            }

            // Global Style Interceptor Look-up Timer
            Timer {
                interval: 500
                running: true
                repeat: true
                onTriggered: {
                    applyBordersRecursively(dmsInstance);
                }
            }

            function applyBordersRecursively(rootItem) {
                if (!rootItem) return;
                
                // If it's a panel capsule or widget background container, force paint our custom border properties
                if (rootItem.toString().includes("BasePill") || rootItem.hasOwnProperty("widgetThickness")) {
                    if (!rootItem.__hasCustomBorder) {
                        var borderWrapper = borderComponent.createObject(rootItem);
                        rootItem.__hasCustomBorder = true;
                    }
                }

                if (rootItem.children) {
                    for (var i = 0; i < rootItem.children.length; i++) {
                        applyBordersRecursively(rootItem.children[i]);
                    }
                }
            }

            Component {
                id: borderComponent
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.width: 2
                    border.color: "#5895dc"
                    radius: parent.hasOwnProperty("radius") ? parent.radius : 12
                    z: 99 // Positions borders above background surfaces smoothly
                }
            }
        }
      '';
    })
  ];
}