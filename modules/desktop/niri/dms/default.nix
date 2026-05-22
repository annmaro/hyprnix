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
          enableKeybinds = true; 
          enableSpawn = true;
        };
      };

      home.packages = with pkgs; [
        dgop # Required for DMS system tracking features
      ];

      xdg.configFile."DankMaterialShell/settings.json".text = builtins.toJSON {
        configVersion = 2;
        
        modules = {
          bar = true;
          notifications = true;
          idle = true;          
          lockscreen = true;    
          wallpaper = false; # Handled perfectly by your separate awww + waypaper setup!
          launcher = false;  # Handled by your native rofi setup
          dock = false;         
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
              "systemTray"         
              "cpuUsage"           
              "memUsage"
              "controlCenterButton" 
            ];
          }
        ];
      };
    })
  ];
}