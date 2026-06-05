{
  pkgs,
  inputs,
  self,
  ...
}:

{
  # 1. System-level environment variables (keep this at the root module level)
  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        imports = [
          inputs.stylix.homeModules.stylix
          inputs.niri.homeModules.stylix
        ];

        stylix = {
          enable = true;
          polarity = "dark";
          enableReleaseChecks = false;

          image = self + "/modules/wallpapers/clay-banks-u27Rrbs9Dwc-unsplash.jpg";

          override = {
            base0A = "607d8b"; # Set to Papirus Bluegrey
            base0D = "607d8b"; # Set primary accent to Papirus Bluegrey
          };

          # Base16 AMOLED Black & Gruvbox Yellow scheme
          /*
            base16Scheme = {
              base00 = "000000"; # Background (AMOLED Absolute Black)
              base01 = "111111"; # Lighter Background (Status bars / panel subtle offsets)
              base02 = "222222"; # Selection Background
              base03 = "555555"; # Comments, Invisible details, Outlines
              base04 = "bbbbbb"; # Dark Text
              base05 = "ffffff"; # Default Text / Main Foreground
              base06 = "e6f0ff"; # Light Text
              base07 = "ffffff"; # Active Text
              base08 = "dd0000"; # Error / Red
              base09 = "ff7b00"; # Orange
              base0A = "fabd2f"; # Yellow (Our structural choice for Accent/Borders)
              base0B = "03fc7b"; # Green / Coral
              base0C = "03fcc6"; # Cyan / Turquoise
              base0D = "fabd2f"; # Accent Color / Active Window Overrides
              base0E = "cc00ff"; # Magenta / Purple
              base0F = "ff6600"; # Brown / Dark Orange
            };
          */

          # 2. Let Stylix handle your Bibata cursor globally
          cursor = {
            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Classic";
            size = 24;
          };

          targets = {
            niri.enable = true;
            gtk = {
              enable = true;
              extraCss = ''
                window.csd > decoration {
                  border: 1px solid #${config.lib.stylix.colors.base0D} !important;
                  outline: 1px solid #${config.lib.stylix.colors.base0D} !important;
                  box-shadow: inset 0 0 0 1px #${config.lib.stylix.colors.base0D}, 0 0 0 1px #${config.lib.stylix.colors.base0D} !important;
                }
                decoration {
                  border: 1px solid #${config.lib.stylix.colors.base0D} !important;
                  outline: 1px solid #${config.lib.stylix.colors.base0D} !important;
                  box-shadow: inset 0 0 0 1px #${config.lib.stylix.colors.base0D}, 0 0 0 1px #${config.lib.stylix.colors.base0D} !important;
                }

                /* Override Thunar Menu Popups for readability */
                window.thunar menu, window.thunar .menu, window.thunar popover {
                  background-color: #${config.lib.stylix.colors.base01} !important;
                  color: #${config.lib.stylix.colors.base05} !important;
                  border: 1px solid #${config.lib.stylix.colors.base0D} !important;
                }
                window.thunar menuitem:hover, window.thunar .menuitem:hover {
                  background-color: #${config.lib.stylix.colors.base02} !important;
                  color: #${config.lib.stylix.colors.base0D} !important;
                }
              '';
            };
            qt.enable = true;
            btop.enable = true;
            kitty.enable = true; # Ensures Stylix automatically hooks into the layout template
            neovim.enable = true;
            firefox = {
              enable = true; # Ensures Stylix automatically hooks into the layout template
              profileNames = [ "default" ]; # Instructs Stylix which specific active profiles to look up
            };
            zen-browser = {
              enable = true; # Ensures Stylix automatically hooks into the layout template
              profileNames = [ "default" ]; # Instructs Stylix which specific active profiles to look up
            };

            # --- DISABLE STYLIX FOR THESE SPECIFIC APPS ---
            vscode.enable = false;
            waybar.enable = false; # We want to manage Waybar's theme manually to leverage its native styling capabilities
            dank-material-shell.enable = false;

            # Add any other apps here if you want to manage their themes manually:
            rofi.enable = false;
            spicetify.enable = false;
            feh.enable = false;
          };

          # Generate a 1x1 solid black pixel on the fly as your wallpaper engine source
          /*
            image = pkgs.runCommand "amoled_black.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
              convert -size 1x1 xc:#000000 $out
            '';
          */

          icons = {
            enable = true;
            package = pkgs.papirus-icon-theme.override { color = "bluegrey"; };
            dark = "Papirus-Dark";
            light = "Papirus-Light";
          };

          fonts = {
            monospace = {
              package = pkgs.nerd-fonts.jetbrains-mono;
              name = "JetBrainsMono Nerd Font";
            };
            sansSerif = {
              package = pkgs.dejavu_fonts;
              name = "DejaVu Sans";
            };
          };
        };
      }
    )
  ];
}
