{ config, pkgs, lib, inputs, ... }: # <-- Make sure 'inputs' is passed here

{
  # 1. Import the official DMS Home Manager module from your flake inputs
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  # 2. Use the dedicated module options instead of just 'home.packages'
  programs.dank-material-shell = {
    enable = true;
    
    # Auto-generates the background systemd services for tracking idle states
    systemd.enable = true; 
  };

  # 3. Hard-lock DMS variables to bypass Matugen auto-theming
  home.sessionVariables = {
    DMS_DISABLE_MATUGEN = "1";
  };

  # 4. Declarative Structural Configurations for the Shell
  xdg.configFile."DankMaterialShell/settings.json".text = builtins.toJSON {
    configVersion = 2;
    
    modules = {
      bar = true;
      notifications = true;
      idle = true;          
      lockscreen = true;    
      wallpaper = false;    
      launcher = false;     
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
}