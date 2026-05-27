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

        currentThemeNametheme = "catppuccin";  # Set your desired DMS theme here (must be installed in DMS's themes directory)
        customThemeFile = "~/.config/DankMaterialShell/themes/catppuccin/theme.json"; # Optional: Path to a custom theme file if you're using one not included in DMS's default themes
        widgetBackgroundColor = "surface";  # Use DMS's color tokens for consistent theming
        widgetColorMode = "colorful";  # "colorful" to use theme colors, "default" for a more neutral look
        dynamicTheming = false;  
        controlCenterTileColorMode = "primary";  # Use primary color for control center tiles
        buttonColorMode = "primary";  # Use primary color for buttons
        cornerRadius = 16; # Apply a consistent border radius to all widgets for a cohesive look
        popupTransparency = 0.80; 
        barElevationEnabled = false;
        blurEnabled = true; # Enable blur for overview and other popups
        blurWallpaperOnOverview = true;
        blurForegroundLayers = false; # Only blur the background for a cleaner look
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
            floating = false;   
            margin = 8;            
            height = 48;            
            #borderRadius = 12;
            
            # Setting bar transparency to 0 hides the background bar background, 
            # allowing only the styled widgets to display as floating pill capsules.
            transparency = 0.80; #   
            widgetTransparency = 0.60; 
            widgetOutlineEnabled = "true"; # Enable widget outlines to create a distinct separation from the background
            widgetOutlineColor = "primary"; # Use the primary color from the theme for widget outlines to maintain a cohesive look
            widgetOutlineOpacity = 1.0; # Fully opaque outlines for maximum contrast against the transparent background
            widgetOutlineThickness = 1;# Thickness of the outline in pixels, adjust as needed for visibility
            fontScale = 1.5; # Scale up the font size for better readability on a high-resolution display, 1.2 = 120% of the default size
            iconScale = 1.4; # Scale up icons to match the increased font size and maintain visual balance, 1.2 = 120% of the default size
            
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

     