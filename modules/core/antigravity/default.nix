{ inputs, pkgs, ... }:

let
  antigravityPkg = inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-no-fhs;
in
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        home.packages = [ antigravityPkg ];

        # Optional: Create a desktop entry if it doesn't exist
        home.file.".local/share/applications/antigravity.desktop" = {
          text = ''
            [Desktop Entry]
            Type=Application
            Exec=antigravity %F
            Icon=antigravity
            Name=Antigravity
            Comment=Antigravity - Google Antigravity agentic IDE
            Categories=Development;IDE;
            Terminal=false
            MimeType=text/plain;
          '';
        };
      }
    )
  ];
}
