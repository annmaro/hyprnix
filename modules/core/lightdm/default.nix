{
  pkgs,
  ...
}:

{
  
  services.xserver.displayManager = {
    defaultSession = "niri";
    
    lightdm = {
      enable = true;
      greeters.gtk = {
        enable = true;
        
        # 1. Reuse your exact theme package and name
        theme = {
          name = "Gruvbox-Dark";
          package = pkgs.gruvbox-gtk-theme;
        };
        
        # 2. Reuse your exact icon theme package and name
        iconTheme = {
          name = "Gruvbox-Plus-Dark";
          package = pkgs.gruvbox-plus-icons;
        };

        # 3. Reuse your exact cursor theme
        cursorTheme = {
          name = "Bibata-Modern-Classic";
          package = pkgs.bibata-cursors;
          size = 24;
        };

        # 4. Use the extraConfig block to drop the background color down to pitch black (#000000)
        # to match your custom GTK3/GTK4 OLED override logic[cite: 2]
        extraConfig = ''
          background=#000000
          panel-position=top
          show-indicators=~language;~session;~power
        '';
      };
    };
  };
}