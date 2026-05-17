{ inputs, pkgs, ... }: 

{
  home-manager.sharedModules = [
    ({ config, ... }: {
      
      # Core Program Configuration
      programs.antigravity = {
        enable = true;
        
        # Inject your custom package right here!
        package = inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-no-fhst;
      };

      # Custom Desktop Entry
      home.file.".local/share/applications/antigravity.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Exec=antigravity %F
        Icon=antigravity
        Name=Antigravity
        Comment=Antigravity - Google AI-powered Code Editor 
        Categories=Development;IDE;
        Terminal=false
        MimeType=text/plain;
      '';
      
    })
  ];
}