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

      # Sets your interface scaling up evenly
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

        # Switch to custom theme mapping to supply custom outline configurations directly
        theme = "custom"; 
        customThemeFile = "%h/.config/DankMaterialShell/themes/custom-border.json";
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
            widgetTransparency = 1.0; # Ensure widget surfaces render clearly with borders
            
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
      # 🎨 THEME CUSTOMIZATION FILE (Injects borders and colors cleanly)
      # =====================================================================
      # By passing the style configuration explicitly through DMS's Matugen outline configuration 
      # schema, your widgets will naturally adapt the blue borders across the entire layout natively.
      xdg.configFile."DankMaterialShell/themes/custom-border.json".text = builtins.toJSON {
        name = "custom-border";
        dark = {
          primary = "#5895dc";
          primaryText = "#ffffff";
          primaryContainer = "#223344";
          secondary = "#5895dc";
          
          # This controls the surface backgrounds behind your widgets
          surfaceContainer = "#1e2030"; 
          surfaceContainerHigh = "#25273a";
          surfaceContainerHighest = "#2f3147";
          background = "#181926";
          backgroundText = "#cad3f5";
          
          # This hooks directly into the native widget borders across Dank Material Shell!
          outline = "#5895dc"; 
          outlineVariant = "#5895dc";
          
          error = "#ed8796";
          warning = "#eed49f";
          info = "#8bd5ca";
        };
      };
    })
  ];
}