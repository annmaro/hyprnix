# Fish Configuration (`modules/core/fish/default.nix`)

The `default.nix` file located at `modules/core/fish/default.nix` manages your shell environment, utilizing Home Manager to configure Fish with a comprehensive set of functions, abbreviations, and integrations tailored for the nixri setup.

## Structure

The configuration is injected into the user's environment via `home-manager.sharedModules` and is centered around the `programs.fish` attribute.

### 1. Core Shell Settings

This section establishes the foundational behavior for Fish.

- **`enable`**: Activates Fish as a managed program.
- **Zoxide Integration**: Automatically enables `zoxide` with Fish integration (`enableFishIntegration`) for smarter directory jumping.

### 2. Interactive Shell Initialization (`interactiveShellInit`)

- Sets up essential key bindings (like `\ca` for beginning of line, `\ce` for end of line).
- Configures default directories for Xmonad (legacy/alternative window manager paths) using Fish's `set -gx`.
- Defines a highly customized, Catppuccin-inspired color palette for **FZF** (Fuzzy Finder) via `FZF_DEFAULT_OPTS`.

### 3. Functions

A set of functions written in Fish script to speed up daily workflows:

- **`UUID`**: Generates a quick UUID.
- **`lf`**: A wrapper function around the `lf` file manager that automatically changes your shell directory to the last directory you were browsing when you exit the file manager.
- **`fnew` / `finit`**: Helper functions to quickly bootstrap new Nix Flake projects using your custom `dev-shells` templates.
- **`cdown`**: A fun countdown timer utility utilizing `figlet` and `lolcat`.
- **`find-store-path`**: Uses `nix-shell` to evaluate and find paths in the Nix store.

### 4. Abbreviations (`shellAbbrs`)

A massive suite of abbreviations (which expand in place as you type) designed to speed up daily workflows, organized into several categories:

#### Global / Utility Abbreviations

- `G`: Expands to `| grep` for quick piping.
- `cls`: Clears the screen.

#### Daily Commands

- **Navigation/Listing**: Replaces standard `ls` with `eza` for icons and better formatting (`l`, `ls`, `ll`, `ld`, `tree`).
- **File Management**: Safer versions of standard tools (`cp -iv`, `mv -iv`, `rm -vI`) and integration with `trash-cli` (`tp`, `tpr`).
- **Tmux**: Quick commands to list (`tml`), attach (`tma`), and fuzzy-find sessions (`tms`).
- **Editors/System**: `vc` (VSCode), `nv` (Neovim), `nf` (microfetch), `bc` (calculator).
- **Fun**: `pokemon` (starts pokego).

#### NixOS Management

A dedicated block of shortcuts for managing the system without typing long commands:

- `nrs`: Rebuild the system (`sudo nixos-rebuild boot --flake .#default`).
- `nhu`: Fast OS switch using `nh` (`nh os switch --hostname default`).
- `nrb`: Fast OS boot using `nh` (`nh os boot --hostname default`).
- `ncg` / `ncb`: Collect garbage and switch boot configuration.
- `nfu` / `nfs`: Flake update and show.
- `da` / `dr`: Dry activate and dry run for system rebuilds.
- `list-gens`: Lists all NixOS generations.
- `vault-edit`: A comprehensive alias to edit SOPS-encrypted secrets.

#### Directory Shortcuts

Quick jumps to frequently used locations:

- `dots`: Navigate to the `nixri` repository.
- `work`, `projects`, `proj`, `dev`, `games`, `media`: Fast navigation to specific mounted drives or folders.

## How to Apply Changes

Changes made to this Fish configuration are applied via Home Manager. You must run your system rebuild script (or `nhu` / `nrs`) and then open a new terminal session for the changes to take effect.
