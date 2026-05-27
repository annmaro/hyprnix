# Browser Configuration (`modules/programs/browser`)

The `modules/programs/browser` directory manages the configuration for web browsers in the nixri system. nixri takes a highly modular approach, allowing you to choose between different Firefox-based browsers (Firefox, Floorp, or Zen) by modifying your `variables.nix` file, while sharing essential components like extensions and bookmarks across them.

## Directory Structure

The `browser/` directory is split into shared configuration files and browser-specific subdirectories.

### Shared Configurations

These files apply globally to your selected browser.

- **`bookmarks.nix`**: Defines a curated, declarative list of bookmarks organized into folders. It includes quick links to media sites, NixOS documentation, physics papers, search engines, and game development assets.
- **`extensions.nix`**: A comprehensive, declarative setup for browser extensions.
  - Automatically forces the installation of essential add-ons such as uBlock Origin, Bitwarden, Proton VPN, Dark Reader, SponsorBlock, and more.
  - Controls UI layout for extensions (e.g., pinning specific icons to the `nav-bar` or `unified-extensions-area`).
  - **uBlock Origin**: Configured extensively with custom lists, advanced settings, and customized Twitch ad-block solutions.
  - **Dark Reader**: Automated settings and optional Catppuccin themes.

### Browser-Specific Subdirectories

Each supported browser has its own dedicated folder containing specific configurations:

#### 1. `firefox/`

Standard Firefox configuration.

- `default.nix`: The main entry module to build the Firefox package and apply its config.
- `policies.nix`: Enterprise-level policy configurations (like disabling telemetry, pocket, and forcing DNS-over-HTTPS).
- `search.nix`: Customizes search engines and keywords.
- `settings.nix`: An extensive list of `about:config` preferences tailored for privacy, performance, and UI tweaks.

#### 2. `floorp/`

Floorp is a privacy-oriented, feature-rich Japanese fork of Firefox.

- Mirrors the structure of the `firefox/` directory (`default.nix`, `policies.nix`, `search.nix`, `settings.nix`).
- Also includes a specific `bookmarks.nix` (which might override or append to the global bookmarks).

#### 3. `zen/`

Zen Browser is another modern Firefox fork focusing on an optimized and unique user interface.

- Includes the standard modular files (`default.nix`, `policies.nix`, `search.nix`, `settings.nix`).
- **`userChrome.css` & `userContent.css`**: Features custom CSS to drastically alter the browser's UI (hiding tabs, altering the nav bar, custom styling for websites), matching the overall nixri desktop aesthetic.

## How it Works

When you set `browser = "firefox"`, `"floorp"`, or `"zen"` in your `variables.nix`, the system evaluates the corresponding subdirectory inside `modules/programs/browser/`. It combines the browser-specific policies, settings, and search engines with the shared global extensions and bookmarks, resulting in a fully configured, ready-to-use browsing experience immediately upon a system rebuild.
