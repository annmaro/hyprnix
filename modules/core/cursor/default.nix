{ inputs, pkgs, ... }:

{
  home-manager.sharedModules = [
    (
      { config, pkgs, ... }:
      {
        home.packages = [
          inputs.cursor.packages.${pkgs.system}.cursor
        ];

        # Optional: Create a desktop entry if it doesn't exist
        home.file.".local/share/applications/cursor.desktop" = {
          text = ''
            [Desktop Entry]
            Type=Application
            Exec=cursor %F
            Icon=cursor
            Name=Cursor
            Comment=Cursor - AI-first Code Editor
            Categories=Development;IDE;
            Terminal=false
            MimeType=text/plain;
          '';
        };
      }
    )
  ];
}
