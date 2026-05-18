# ZSH Configuration (`modules/core/zsh/default.nix`)

The `default.nix` file located at `modules/core/zsh/default.nix` manages your shell environment, utilizing Home Manager to configure Zsh with a comprehensive set of plugins, themes, and aliases tailored for the Hyprnix setup.

## Structure

The configuration is injected into the user's environment via `home-manager.sharedModules` and is centered around the `programs.zsh` attribute.

### 1. Core Shell Settings

This section establishes the foundational behavior and quality-of-life improvements for Zsh.

- **`enable`**: Activates Zsh as a managed program.
- **Extensions**: Automatically enables `autosuggestion`, `syntaxHighlighting`, and `enableCompletion` for a modern, responsive typing experience.
- **History Management**:
  - Generous history size (`100000`).
  - Stored cleanly in `$XDG_DATA_HOME/zsh/history`.
  - Various `setopt` commands are applied (e.g., `extended_history`, `hist_ignore_dups`, `share_history`) to ensure shell history is preserved sensibly across multiple terminal sessions.
- **`dotDir`**: Keeps the home directory clean by storing Zsh configs in `$XDG_CONFIG_HOME/zsh`.

### 2. Plugins and Hooks

- **Oh My Zsh**: Enabled with the `git`, `gitignore`, and `z` (directory jumping) plugins.
- **`initContent`**:
  - Initializes **Starship** as the cross-shell prompt (if installed).
  - Evaluates the **Direnv** hook to allow automatic environment switching when entering directories.
  - Sets up essential key bindings (like `^a` for beginning of line, `^e` for end of line) and shell options.

### 3. Environment Variables (`envExtra`)

Sets global environment variables when the shell initializes.

- Configures default directories for Xmonad (legacy/alternative window manager paths).
- Defines a highly customized, Catppuccin-inspired color palette for **FZF** (Fuzzy Finder) via `FZF_DEFAULT_OPTS`.

### 4. Aliases

A massive suite of aliases designed to speed up daily workflows, organized into several categories:

#### Global Aliases

- `UUID`: Generates a quick UUID.
- `G`: Expands to `| grep` for quick piping.

#### Utility Functions

- **`lf`**: A wrapper function around the `lf` file manager that automatically changes your shell directory to the last directory you were browsing when you exit the file manager.
- **`fnew` / `finit`**: Helper functions to quickly bootstrap new Nix Flake projects using your custom `dev-shells` templates.
- **`cdown`**: A fun countdown timer utility utilizing `figlet` and `lolcat`.

#### Daily Commands

- **Navigation/Listing**: Replaces standard `ls` with `eza` for icons and better formatting (`l`, `ls`, `ll`, `ld`, `tree`).
- **File Management**: Safer versions of standard tools (`cp -iv`, `mv -iv`, `rm -vI`) and integration with `trash-cli` (`tp`, `tpr`).
- **Tmux**: Quick commands to list (`tml`), attach (`tma`), and fuzzy-find sessions (`tms`).
- **Editors/System**: `vc` (VSCode), `nv` (Neovim), `cls` (clear), `nf` (microfetch).

#### NixOS Management

A dedicated block of shortcuts for managing the system without typing long commands:

- `nrs`: Rebuild the system (`sudo nixos-rebuild boot --flake .#default`).
- `nhu`: Fast OS switch using `nh` (`nh os switch --hostname default`).
- `ncg`: Collect garbage and switch boot configuration.
- `nfu` / `nfs`: Flake update and show.
- `vault-edit`: A comprehensive alias to edit SOPS-encrypted secrets.

#### Directory Shortcuts

Quick jumps to frequently used locations:

- `dots`: Navigate to the `hyprnix` repository.
- `work`, `projects`, `dev`, `games`, `media`: Fast navigation to specific mounted drives or folders.

## How to Apply Changes

Changes made to this Zsh configuration are applied via Home Manager. You must run your system rebuild script (or `nhu` / `nrs`) and then open a new terminal session for the changes to take effect.
