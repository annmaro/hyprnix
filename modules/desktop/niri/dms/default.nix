{ config, pkgs, lib, inputs, ... }:

{
  home-manager.sharedModules = [
    (_: { 
      imports = [
        inputs.dms.homeModules.dank-material-shell
        inputs.dms.homeModules.niri # ◄ 1. Enforce native Niri features & auto-spawning
      ];

      programs.dank-material-shell = {
        enable = true;
        systemd.enable = true; 
        
        # ◄ 2. Automatically bind native DMS media control shortcuts
        niri = {
          enableKeybinds = false; # Disable DMS's built-in keybinds to prevent conflicts with your custom ones
          enableSpawn = false;   # Disable DMS's built-in autostart to prevent conflicts with your custom spawn-at-startup setup
        };
      };

      home.packages = with pkgs; [
        dgop # Required for DMS system tracking features
      ];

      xdg.configFile."DankMaterialShell/settings.json".text = builtins.toJSON {
        configVersion = 2;
        disableWallpaper = true; # Handled perfectly by your separate awww + waypaper setup!
        
        modules = {
          bar = true;
          notifications = true;
          idle = true;          
          lockscreen = true;    
          wallpaper = false; # Handled perfectly by your separate awww + waypaper setup!
          launcher = false;  # Handled by your native rofi setup
          dock = false;         
        };

        # ==========================================
        # 📊 BAR INTERFACE & SIZING CONFIGURATION
        # ==========================================
        bar = {
          # Increase this value to make the top bar larger.
          # Default is usually around 28-32. Try 40 or 44 for a clearer size.
          height = 42; 
          
          # Optional: You can also adjust the font size here if the text 
          # feels too small inside your newly sized bar
          fontSize = 12;

        weather = {
          enabled = true;
          latitude = 23.6303;     # Coordinates for Ramgarh, Jharkhand, India 
          longitude = 85.5216;
          unit = "celsius";     # "celsius" or "fahrenheit"
          interval = 1800;      # Refresh period calculation metric (in seconds)
        };

        theme = "catppuccin-macchiato"; 
        dynamicTheming = false;

        barConfigs = [
          {
            id = "default";
            name = "Main Bar";
            enabled = true;
            position = "top";
            floating = true;       
            margin = 8;            
            height = 30;           
            borderRadius = 6;
            opacity = 0.92;

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
        };
      };
    })
  ];
}