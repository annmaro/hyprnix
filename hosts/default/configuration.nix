{ lib, ... }:
let
  vars = import ./variables.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ./host-packages.nix

    # Core Modules (Don't change unless you know what you're doing)
    ../../modules/scripts
    ../../modules/core/boot
    ../../modules/core/bash
    ../../modules/core/zsh
    ../../modules/core/starship
    ../../modules/core/fonts
    ../../modules/core/git
    ../../modules/core/hardware
    ../../modules/core/network
    ../../modules/core/nh
    ../../modules/core/packages
    ../../modules/core/printing
    ../../modules/core/sddm
    ../../modules/core/security
    ../../modules/core/services
    ../../modules/core/syncthing
    ../../modules/core/system
    ../../modules/core/users
    ../../modules/core/flatpak
    # ../../modules/core/virtualisation.nix
    # ../../modules/core/dlna.nix

    # Optional
    ../../modules/hardware/drives # Automatically mount extra external/internal drives
    ../../modules/hardware/video/${vars.videoDriver}.nix # Enable gpu drivers defined in variables.nix
    ../../modules/desktop/${vars.desktop} # Set window manager defined in variables.nix
    ../../modules/programs/browser/${vars.browser} # Set browser defined in variables.nix
    ../../modules/programs/terminal/${vars.terminal} # Set terminal defined in variables.nix
    ../../modules/programs/editor/${vars.editor} # Set editor defined in variables.nix
    ../../modules/programs/cli/${vars.tuiFileManager} # Set file-manager defined in variables.nix
    ../../modules/programs/cli/tmux
    ../../modules/programs/editor/neovim
    ../../modules/programs/browser/zen
    ../../modules/programs/cli/direnv
    ../../modules/programs/terminal/fastfetch
    ../../modules/programs/misc/cpufreq
    ../../modules/programs/cli/lazygit
    ../../modules/programs/cli/cava
    ../../modules/programs/cli/btop
    ../../modules/programs/media/discord
    ../../modules/programs/media/spicetify
    # ../../modules/programs/media/youtube-music
    # ../../modules/programs/media/thunderbird
    # ../../modules/programs/media/obs-studio
    ../../modules/programs/media/mpv
    ../../modules/programs/misc/tlp
    ../../modules/programs/misc/thunar
    ../../modules/programs/misc/lact # GPU fan, clock and power configuration
  ]
  ++ lib.optional (vars.games == true) ../../modules/core/games;
}
