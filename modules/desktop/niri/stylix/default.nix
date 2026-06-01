{ pkgs, ... }:

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
        stylix = {
          enable = true;
          polarity = "dark";

          # Base16 AMOLED Black & Gruvbox Yellow scheme
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

          # 2. Let Stylix handle your Bibata cursor globally
          cursor = {
            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Classic";
            size = 24;
          };

          targets = {
            waybar.enable = true;
            niri.enable = true;
            gtk.enable = true;
            qt.enable = true;
            feh.enable = true;
            chromium.enable = true;

            # --- DISABLE STYLIX FOR THESE SPECIFIC APPS ---
            vscode.enable = false;
            kitty.enable = false;
            neovim.enable = false;

            # Add any other apps here if you want to manage their themes manually:
            rofi.enable = false;
            # btop.enable = false;
          };

          # Generate a 1x1 solid black pixel on the fly as your wallpaper engine source
          image = pkgs.runCommand "amoled_black.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
            convert -size 1x1 xc:#000000 $out
          '';

          iconTheme = {
            enable = true;
            package = pkgs.gruvbox-plus-icons;
            name = "Gruvbox-Plus-Dark";
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
