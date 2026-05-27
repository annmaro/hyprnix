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

        # ==========================================
        # 🎨 NATIVE WIDGET STYLING & BORDERS (Root Level)
        # ==========================================
        borderEnabled = true;               # Enables native widget/bar borders
        borderColor = "outline";          # Custom blue outline
        borderThickness = 2;                # Set to 2px
        borderOpacity = 1.0;                # Fully opaque outline
        widgetTransparency = 0.90;          # Set widget background to 90% opacity for a subtle see-through effect  
        squareCorners = false;              # Keep corners rounded for pill shape
        gothCornersEnabled = false;         # Disabled to ensure standard rounded capsule styling

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
            floating = false;       
            margin = 0;            
            height = 76;           
            borderRadius = 0;
            
            # Setting bar transparency to 0 hides the background bar, 
            # allowing only the styled widgets to display as floating pill capsules.
            transparency = 0.70;    
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