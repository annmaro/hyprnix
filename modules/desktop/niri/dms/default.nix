{ config, pkgs, lib, inputs, ... }:

{
  home-manager.sharedModules = [
    (_: { 
      imports = [
        inputs.dms.homeModules.dank-material-shell
        inputs.dms.homeModules.niri # ◄ 1. Enforce native Niri features & auto-spawning
      ];
      
      lib.niri = {
        actions = {
          spawn = a: b: {}; 
        };
      };

      programs.dank-material-shell = {
        enable = true;
        systemd.enable = true; 
 
        niri = {
          enableKeybinds = false; # Disable DMS's built-in keybinds to prevent conflicts with your custom ones
          enableSpawn = false;   # Disable DMS's built-in autostart to prevent conflicts with your custom spawn-at-startup setup
        };
      };

        # 🛠️ ADD THIS BLOCK: Forces DMS to scale up fonts and icons nicely together
        systemd.user.services.dms = {
          Service = {
            Environment = [
            "QT_SCALE_FACTOR=1.2" # 1.2 = 120% size. Adjust this up or down as needed!
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
        theme = "catppuccin-macchiato"; 
        dynamicTheming = false;      

        styling = {
          layers = {
            background = "#180F39D9";
          };
        };

        weatherEnabled = true;
        weatherLocation = "Ramgarh, Jharkhand, India";
        weatherCoordinates = "23.6303,85.5216";
        useFahrenheit = false;

        barConfigs = [
          {
            id = "default";
            name = "Main Bar";
            enabled = true;
            position = "top";
            floating = true;       
            margin = 8;            
            height = 76;           
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