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

        currentThemeNametheme = "catppuccin-mocha";  # Set your desired DMS theme here (must be installed in DMS's themes directory)
        widgetBackgroundColor = "surface";  # Use DMS's color tokens for consistent theming
        widgetColorMode = "colorful";  # "colorful" to use theme colors, "default" for a more neutral look
        dynamicTheming = false;  
        controlCenterTileColorMode = "primary";  # Use primary color for control center tiles
        buttonColorMode = "primary";  # Use primary color for buttons
        cornerRadius = 16;
        popupTransparency = 0.80; 
        barElevationEnabled = false;
        blurEnabled = true; # Enable blur for overview and other popups
        blurWallpaperOnOverview = true;
        blurForegroundLayers = false; # Only blur the background for a cleaner look
        blurAmount = 20;
        blurSaturation = 1.2;
        blurContrast = 1.1;
        blurBrightness = 1.0;   

        weatherEnabled = true;
        weatherLocation = "Ramgarh, Jharkhand, India";
        weatherCoordinates = "23.5987759,85.5369156";
        useFahrenheit = false;
        useAutoLocation = false;

        barConfigs = [
          {
            id = "default";
            name = "Main Bar";
            enabled = true;
            position = "top";
            floating = true; # Enable floating to allow for custom margins and independent styling  
            margin = 8;            
            height = 48;           
            #borderRadius = 12;
            
            # Setting bar transparency to 0 hides the background bar background, 
            # allowing only the styled widgets to display as floating pill capsules.
            transparency = 0.80;    
            widgetTransparency = 0.60; 
            widgetOutlineEnabled = "true";
            widgetOutlineColor = "primary";
            widgetOutlineOpacity = 1.0;
            widgetOutlineThickness = 1;
            fontScale = 1.2;
            iconScale = 1.2;
            
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
  })
  ];
}  

     