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

        theme = "amoledBlack-black"; 
        dynamicTheming = false; # Disable dynamic theming to maintain a consistent look across all widgets, regardless of the current wallpaper or system theme. This ensures that your custom color choices are always applied.     
        
        widgetBackgroundColor = "s";  # Use DMS's color tokens for consistent theming
        widgetColorMode = "colorful";  # "colorful" to use theme colors, "default" for a more neutral look
        buttonColorMode = "primary";  # Use primary color for buttons
        popupTransparency = 1; # 1 = fully opaque, 0 = fully transparent. Adjust for more or less see-through popups. 
        
        cornerRadius = 16; # Apply a consistent border radius to all widgets for a cohesive look
        gothCornersEnabled = true; # Enable goth corners for a more modern and edgy aesthetic
        squareCorners = true; # Set to true to make all corners square, overriding gothCornersEnabled for a more classic look

        blurEnabled = true; # Enable blur for overview and other popups
        blurWallpaperOnOverview = true; # Blur the wallpaper when opening the overview for better focus on windows
        blurForegroundLayers = false; # Only blur the background for a cleaner look

        weatherEnabled = true;
        weatherLocation = "Ramgarh, Jharkhand, India";
        weatherCoordinates = "23.5987759,85.5369156";
        useFahrenheit = false;
        useLocation = false; # Set to true to allow DMS to auto-detect location for weather. If false, it will use the specified location above.

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
            transparency = 0.70; # Adjust bar transparency to your liking (0 = fully transparent, 1 = fully opaque). A value around 0.7 can create a nice frosted glass effect while still allowing the wallpaper to subtly show through behind the widgets.    
            widgetTransparency = 1; # Set widget transparency to 1 for fully opaque widgets that stand out against the transparent bar background 
            
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