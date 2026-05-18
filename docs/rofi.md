# Rofi Configuration & Theming

This document explains how Rofi is configured in the Hyprnix setup and how you can declaratively change its theme and color schemes.

## Overview

Rofi's base configuration is managed by Nix via Home Manager. The main files are located at:

- `modules/desktop/hyprland/programs/rofi/default.nix`: The entry point that enables Rofi, configures plugins, and links the local `launchers`, `colors`, and `images` directories to `~/.config/rofi/`.
- `modules/desktop/hyprland/programs/rofi/config.nix`: Contains all the general Rofi settings such as matching, history, sorting, window switcher behaviors, and keybindings.

## Where are the Themes Stored?

Hyprnix uses a collection of Rofi themes curated by Aditya Shakya (@adi1090x). These assets are copied into your system's `~/.config/rofi/` directory on build.

Inside `modules/desktop/hyprland/programs/rofi/`:

- **`launchers/`**: Contains various structural theme types (e.g., `type-1` to `type-7`). Each type folder has multiple `style-X.rasi` files.
- **`colors/`**: Contains color schemes (e.g., `catppuccin.rasi`, `tokyonight.rasi`, `dracula.rasi`, etc.).
- **`images/`**: Contains background images used by some theme styles.

## How to Change the Theme Declaratively

Unlike editing a global config file, the theme in Hyprnix is set explicitly in the scripts that launch Rofi. This allows you to use different themes for different Rofi modes (e.g., one theme for the application launcher, and another for the window switcher).

To change the theme declaratively, modify the **Launcher Script**:

1. Open `modules/scripts/launcher.nix` in your text editor.
2. Locate the `case $1 in` block where different Rofi modes (`drun`, `window`, `file`, etc.) are defined.
3. For the mode you want to change, modify the `rofi_theme` variable.

For example, to change the application launcher (`drun`) theme:

```bash
  drun)
    # Change the type-X and style-Y to your preferred theme.
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-7/style-2.rasi"
    # ...
    rofi -show drun -theme "$rofi_theme"
```

### Changing the Keybinds Menu Theme

The keybinds display menu also uses Rofi but is launched from a different script. To change its theme:

1. Open `modules/desktop/hyprland/scripts/keybinds-rofi.sh`.
2. Modify the `rofi_theme` variable to point to your desired style.

```bash
rofi_theme="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-4/style-4.rasi"
```

## How to Change Colors

Some Rofi themes (especially `type-1` through `type-5`) share a global color configuration. They import their colors from a shared `colors.rasi` file.

To change the color scheme for these themes:

1. Open the corresponding shared color file, for example: `modules/desktop/hyprland/programs/rofi/launchers/type-4/shared/colors.rasi`.
2. Change the `@import` directive to load a different color palette from the `colors/` directory.

```css
/* Change 'catppuccin.rasi' to 'dracula.rasi', 'tokyonight.rasi', etc. */
@import "~/.config/rofi/colors/catppuccin.rasi"
```

*Note: Some newer styles (like those in `type-6` and `type-7`) define their colors inline within the `style-X.rasi` file itself. To change colors for those styles, edit the `* { ... }` color variables block directly in the respective style file.*

## Applying Changes

Once you've made changes to the `launcher.nix`, `keybinds-rofi.sh`, or the Rasi files, rebuild your NixOS system or update your Home Manager configuration (e.g., by running your custom rebuild script) for the changes to take effect.

## Troubleshooting: Micro-stutter or Lag with Images

That micro-stutter or lag when you press your hotkey is a very common quirk when adding images to Rofi. Because Rofi is designed to be extremely lightweight, it doesn't run as a persistent background service (daemon) by default. This means every single time you press your shortcut, Rofi has to wake up, read the image file from your hard drive, decode it, and scale it down to fit the window.

If your background image is a high-resolution 1080p or 4K wallpaper (which is usually the case with these themes), the CPU has to do a lot of heavy lifting in those few milliseconds, causing that noticeable delay.

Here is how to eliminate the lag and make Rofi instant again.

### 1. The Quick Fix: Downscale and Compress

The absolute best way to fix this is to pre-scale the image to the exact size Rofi needs. Rofi windows are usually quite small (e.g., 600x400 pixels). There is no reason to force it to load a 4K image.

Since you are on NixOS, you don't even need to permanently install an image editor. You can use ImageMagick temporarily to create a lightning-fast, optimized version of your background.

Run this command in your terminal (make sure to replace `telescope.png` with your actual image filename):

```bash
# This creates a much smaller, compressed version of the image
nix run nixpkgs#imagemagick -- convert ~/hyprnix/modules/desktop/hyprland/programs/rofi/images/telescope.png -resize 800x ~/hyprnix/modules/desktop/hyprland/programs/rofi/images/telescope-fast.jpg
```

### 2. If ImageMagick is already installed

If you already have ImageMagick installed on your system, you can run the commands directly without `nix run`.

**For a single file:**

```bash
magick ~/hyprnix/modules/desktop/hyprland/programs/rofi/images/your-image.png -resize 800x ~/hyprnix/modules/desktop/hyprland/programs/rofi/images/your-image-fast.png
```

**To batch convert all images in the folder:**

```bash
cd ~/hyprnix/modules/desktop/hyprland/programs/rofi/images/ 

for img in *.{png,jpg,jpeg}; do
    # Check if the file exists and skip files that already have "-fast" in the name
    if [[ -f "$img" && "$img" != *"-fast"* ]]; then
        # Strip the old extension, add -fast.png, and convert
        magick "$img" -resize 800x "${img%.*}-fast.png"
        echo "Optimized: $img -> ${img%.*}-fast.png"
    fi
done
```

### 3. Update your Theme File

Now, update your `.rasi` file to point to this new, lightweight image.

Open your theme file (e.g., `modules/desktop/hyprland/programs/rofi/launchers/type-2/style-2.rasi`).

Update the `background-image` line to use the new `.png`:

```css
inputbar {
    background-image: url("~/.config/rofi/images/your-image-fast.png", width);
}
```

### 4. Rebuild and Test

Run your system rebuild command (`sudo nixos-rebuild switch --flake .#default`).

Because the new image is significantly smaller in both dimensions and file size (often dropping from 3MB to around 50KB), Rofi will be able to parse and paint it to your screen almost instantly.
