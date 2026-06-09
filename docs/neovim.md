# Neovim Configuration (`modules/programs/editor/neovim`)

The `modules/programs/editor/neovim` directory manages the configuration for Neovim in the nixri system. nixri uses [NVF](https://github.com/notashelf/nvf) to declaratively configure Neovim, its plugins, and its themes directly through Nix, providing a highly modular and reproducible setup.

## Directory Structure

The Neovim configuration is split into modular files to keep the setup organized and maintainable.

### Core Configurations

- **`default.nix`**: The main entry module that imports all the other Neovim configuration files. It ties the entire setup together and enables NVF for the system.
- **`options.nix`**: Defines core Neovim options such as indentation rules, folding, clipboard providers, and UI options. It also configures the base16 dynamic color palette using Stylix to ensure Neovim perfectly matches the system-wide colorscheme.
- **`keymaps.nix`**: A centralized file for custom keybindings. It maps normal, visual, and insert mode shortcuts for navigating splits, managing buffers, and triggering plugin features.

### Plugin Integrations

- **`languages.nix`**: Manages Language Server Protocols (LSP), Treesitter parsers, formatters, and linters for various programming languages (e.g., Nix, Python, Rust, Go). It ensures the editor is equipped with modern IDE capabilities like auto-completion and diagnostics.
- **`picker.nix`**: Configures fuzzy-finding and picking tools (typically Telescope or Fzf-lua). It includes keymaps and settings for searching files, live grepping, finding buffers, and navigating help tags.
- **`utils.nix`**: Handles essential utility plugins that improve the editing experience. This includes plugins for Git integration, auto-pairing brackets, smooth scrolling, and other workflow enhancements.
- **`mini.nix`**: Configures modules from the `mini.nvim` library, which provides lightweight, focused plugins for specific tasks (like surrounding text, aligning, or statuslines).
- **`snacks.nix`**: Sets up `snacks.nvim`, a collection of small QoL plugins for Neovim that add extra polish and functionality without heavy overhead.

## How it Works

When Neovim is enabled in your `variables.nix`, the system evaluates the modules inside this directory. Instead of relying on traditional Lua scripts in `~/.config/nvim`, NVF compiles these Nix expressions into an optimized Lua configuration during the system rebuild.

The `options.nix` file plays a special role by capturing the current `stylix` base16 colors and passing them explicitly into NVF. This approach guarantees that Neovim's syntax highlighting, plugin UIs, and backgrounds adapt seamlessly whenever you switch your system's global theme.
