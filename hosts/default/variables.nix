{
  # User Configuration
  username = "anand"; # Your username (auto-set with install.sh, live-install.sh, rebuild)
  desktop = "hyprland"; # Options: hyprland, i3-gaps, gnome, plasma6
  terminal = "kitty"; # Options: kitty, alacritty
  editor = "vscode"; # Options: nixvim, vscode, helix, nvchad, neovim
  browser = "zen"; # Options: firefox, floorp, zen
  tuiFileManager = "yazi"; # Options: yazi, lf
  shell = "zsh"; # Options: zsh, bash
  games = true; # Whether to enable the gaming module

  # Hardware Configuration
  videoDriver = "intel"; # CRITICAL: Choose your GPU driver (nvidia, amdgpu, intel)
  hostname = "hyprnix"; # Your system hostname

  # Localization
  clock24h = true; # 24H or 12H clock in waybar
  kbdLayout = "us"; # Keyboard layout
  kbdVariant = " "; # Keyboard variant (can be empty)
  consoleKeymap = "us"; # TTY keymap
}
