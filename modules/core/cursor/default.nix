{ inputs, pkgs, ... }:

let
  cursorPkg = inputs.cursor.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        home.packages = [ cursorPkg ];

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
