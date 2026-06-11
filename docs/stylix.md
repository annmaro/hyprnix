# Stylix Global Theming (`modules/desktop/niri/stylix`)

Stylix is a NixOS module that provides system-wide colorschemes and typography management. In the nixri configuration, Stylix is heavily integrated to provide a unified, deeply customized aesthetic across all desktop environments, application toolkits, and terminal configurations natively.

## Configuration Structure

The configuration lives in `modules/desktop/niri/stylix/default.nix`. 

### Theming Base & Palette

The configuration uses a base16 color scheme defined declaratively in Nix.
- **Polarity**: Forced to `"dark"` globally to ensure applications default to dark-mode variants.
- **Base16 Scheme**: A customized Catppuccin Macchiato/Mocha blend, defining all 16 distinct colors (backgrounds, foregrounds, and accents) explicitly within the `base16Scheme` block.
- **Wallpaper Engine Seed**: The `image` property points to `${self}/modules/wallpapers/tree.jpg`. While Stylix can use this image to auto-generate colors, nixri specifies the `base16Scheme` manually to guarantee exact hex values and prevent unexpected shifting.

### Typography and Cursors

- **Fonts**: 
  - Monospace: `JetBrainsMono Nerd Font` (via `pkgs.nerd-fonts.jetbrains-mono`)
  - Sans-Serif: `DejaVu Sans` (via `pkgs.dejavu_fonts`)
- **Cursor**: The `catppuccin-mocha-mauve-cursors` package is injected globally, locked firmly at size `24`.

### Dynamic Target Integrations

Stylix injects the defined Base16 colors, fonts, and cursors directly into supported applications via the `targets` block:

#### Auto-Themed Targets
- **GTK (`gtk`)**: Enforces GTK themes and injects extra raw CSS. This custom CSS explicitly strips borders and drop-shadows from client-side window decorations (`csd`) to fit Niri's flat aesthetic, and overrides Thunar's right-click menu popup colors for better readability.
- **Qt (`qt`)**: Hooks the Kvantum engine into `qt5ct`/`qt6ct` to force Qt-based programs (like VLC or OBS) to align with the global dark theme.
- **Applications**: `btop`, `swaylock`, `firefox`, and `zen-browser` have automatic CSS/config generation enabled, instantly inheriting the base16 scheme.

#### Manually Themed Targets (Disabled in Stylix)
- `vscode`, `rofi`, `foot`, `neovim`, `waybar`, `dank-material-shell`, `spicetify`, `cava`, `feh`.
- *Why are they disabled?* These applications are explicitly disabled in Stylix because they require highly specialized, custom configurations. Instead of using Stylix's generic configuration templates, these apps pull the global colors manually via `config.lib.stylix.colors.baseXX` (as seen in the Rofi and Neovim docs) to construct highly complex, custom UI designs without conflicts.

### Icon System

- **Icons**: Forces the `Papirus` icon theme across the desktop. It is explicitly overridden using `pkgs.papirus-icon-theme.override { color = "violet"; }` to perfectly harmonize with the global Catppuccin Mauve accent color.
