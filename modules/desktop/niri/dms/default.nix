{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  home-manager.sharedModules = [
    (
      { config, ... }:

      let
        bgColor = "#${config.lib.stylix.colors.base00}"; # Background
        fgColor = "#${config.lib.stylix.colors.base05}"; # Default Text
        accentColor = "#${config.lib.stylix.colors.base0D}"; # Primary Accent
        surfaceMuted = "#${config.lib.stylix.colors.base03}";

        amoledBlackTheme = {
          dark = {
            background = "#000000";
            backgroundText = fgColor;
            error = "#dd0000";
            info = "#03fcc6";
            name = "AmoledBlack";
            outline = "#555555";
            primary = accentColor;
            primaryContainer = "#03fcc6";
            primaryText = "#000000";
            secondary = surfaceMuted;
            surface = bgColor;
            surfaceContainer = bgColor;
            surfaceContainerHigh = "#222222";
            surfaceContainerHighest = "#555555";
            surfaceText = fgColor;
            surfaceTint = accentColor;
            surfaceVariant = "#222222";
            surfaceVariantText = "#bbbbbb";
            warning = accentColor;
          };
          light = {
            background = "#000000";
            backgroundText = fgColor;
            error = "#dd0000";
            info = "#03fcc6";
            name = "AmoledBlack";
            outline = "#555555";
            primary = accentColor;
            primaryContainer = "#03fcc6";
            primaryText = "#000000";
            secondary = surfaceMuted;
            surface = bgColor;
            surfaceContainer = bgColor;
            surfaceContainerHigh = "#222222";
            surfaceContainerHighest = "#555555";
            surfaceText = fgColor;
            surfaceTint = accentColor;
            surfaceVariant = "#222222";
            surfaceVariantText = "#bbbbbb";
            warning = accentColor;
          };
        };
      in
      {
        imports = [
          inputs.dms.homeModules.dank-material-shell
          inputs.dms.homeModules.niri # Enforce native Niri features & auto-spawning
          ./logo.nix # Custom system logo plugin with inline QML for better performance and easier management
        ];

        programs.dank-material-shell = {
          enable = true;
          systemd.enable = true;

          niri = {
            enableKeybinds = false; # Disable DMS's built-in keybinds to prevent conflicts with your custom ones
            enableSpawn = false; # Disable DMS's built-in autostart to prevent conflicts with your custom spawn-at-startup setup
          };
        };

        home.packages = with pkgs; [
          dgop # Required for DMS system tracking features
          nerd-fonts.jetbrains-mono
          material-symbols
          material-design-icons
        ];

        # =====================================================================
        # 🎨 AUTOMATIC THEME GENERATION
        # =====================================================================
        # Nix now dynamically generates the file using your Stylix palette!
        xdg.configFile."DankMaterialShell/themes/amoledBlack/theme.json".text =
          builtins.toJSON amoledBlackTheme;
        xdg.configFile."DankMaterialShell/nix.png".source = ./nix.png; # Symlink the local nix.png into the expected path in the home directory for DMS to use as the profile image

        # =====================================================================
        # 🎨 SETTINGS.JSON & SESSION STATE CONFIGURATION
        # =====================================================================

        home.activation.dmsWeather = config.lib.dag.entryAfter [ "writeBoundary" ] ''
          SESSION_FILE="$HOME/.local/state/DankMaterialShell/session.json"
          if [ -f "$SESSION_FILE" ] && [ ! -L "$SESSION_FILE" ]; then
            $DRY_RUN_CMD ${pkgs.jq}/bin/jq '.weatherLocation = "Ramgarh, Jharkhand, India" | .weatherCoordinates = "23.5987759,85.5369156"' "$SESSION_FILE" > "$SESSION_FILE.tmp" && \
            $DRY_RUN_CMD mv "$SESSION_FILE.tmp" "$SESSION_FILE"
          elif [ ! -f "$SESSION_FILE" ]; then
            $DRY_RUN_CMD mkdir -p "$HOME/.local/state/DankMaterialShell"
            $DRY_RUN_CMD echo '{"weatherLocation": "Ramgarh, Jharkhand, India", "weatherCoordinates": "23.5987759,85.5369156"}' > "$SESSION_FILE"
          fi
        '';

        xdg.configFile."DankMaterialShell/settings.json".text = builtins.toJSON {
          configVersion = 6;
          screenPreferences = {
            wallpaper = [ ]; # This replaces the old disableWallpaper = true flag in DMS v6
          };

          modules = {
            bar = true;
            notifications = true;
            idle = true;
            lockscreen = true;
            wallpaper = false; # false to keep it managed by your separate awww/swaybg
            launcher = false; # Handled by your native rofi setup
            dock = false;
          };

          dynamicTheming = false; # Disable dynamic theming to maintain a consistent look across all widgets, regardless of the current wallpaper or system theme. This ensures that your custom color choices are always applied.
          currentThemeName = "custom"; # Use "custom" to apply your custom theme file specified below
          customThemeFile = "${config.home.homeDirectory}/.config/DankMaterialShell/themes/amoledBlack/theme.json"; # Path to your custom theme file, which is generated dynamically from your Stylix palette. Make sure this path matches where your theme file is generated and stored.

          fontFamily = config.stylix.fonts.sansSerif.name;
          monoFontFamily = config.stylix.fonts.monospace.name;

          profileImage = "${config.home.homeDirectory}/.config/DankMaterialShell/nix.png"; # Set the path to your profile image for display in the overview and other DMS components. Make sure the image exists at this location and is in a supported format (e.g., PNG, JPEG).
          launcherLogoMode = "os"; # Set to "os" to display your custom NixOS system logo (SystemLogo.qml) inside the launcher button

          widgetBackgroundColor = "s"; # Use DMS's color tokens for consistent theming
          widgetColorMode = "colorful"; # "colorful" to use theme colors, "default" for a more neutral look
          buttonColorMode = "primary"; # Use primary color for buttons

          popupTransparency = 0.40; # Set popup transparency to create a frosted glass effect for notifications and other popups, allowing the wallpaper to subtly show through while keeping the content readable. Adjust as needed for your preferred balance of visibility and aesthetics.
          cornerRadius = 16; # Apply a consistent border radius to all widgets for a cohesive look

          blurEnabled = true; # Enable blur for overview and other popups
          blurWallpaperOnOverview = true; # Blur the wallpaper when opening the overview for better focus on windows
          blurForegroundLayers = false; # Only blur the background for a cleaner look

          systemTrayIconTintMode = "primary"; # Tint system tray icons with the primary color for a more cohesive look. Adjust as needed based on your custom theme's color palette for optimal aesthetics.
          systemTrayIconTintSaturation = 40; # Increase saturation of tinted system tray icons to make them pop against the background. Adjust as needed based on your custom theme's color palette and desired level of emphasis on the icons.
          systemTrayIconTintStrength = 150; # Increase tint strength for system tray icons to create a more pronounced effect and better integration with the overall theme. Adjust as needed based on your custom theme's color palette and desired level of emphasis on the icons.

          barConfigs = [
            {
              id = "default";
              name = "Main Bar";
              enabled = true;
              position = "top";
              spacing = 0; # Space between the bar and screen edges

              # Setting bar transparency to 0 hides the background bar background,
              # allowing only the styled widgets to display as floating pill capsules.
              transparency = 0.50; # Set bar transparency to create a floating effect for the widgets. A value around 0.5 can create a nice balance where the bar background is subtle but still provides some separation from the wallpaper. Adjust as needed for your preferred look, keeping in mind that lower values will make the bar more transparent and higher values will make it more opaque.
              widgetTransparency = 0.70; # Set widget transparency to create a layered look with the bar. A value around 0.7 can create a nice frosted glass effect for the widgets, allowing the bar background to subtly show through while keeping the widget content readable. Adjust as needed for your preferred balance of visibility and aesthetics.

              widgetOutlineEnabled = true; # Enable outlines for widgets to enhance visibility and separation from the background
              widgetOutlineColor = "primary"; # Use primary color for widget outlines to create a cohesive look with the rest of the theme. Adjust as needed based on your custom theme's color palette for optimal contrast and aesthetics.
              widgetOutlineOpacity = 1.0; # Set widget outline opacity to fully opaque for maximum visibility and contrast against the background. Adjust as needed for a more subtle effect while maintaining clear separation of widgets from the wallpaper.
              widgetOutlineThickness = 1; # Set widget outline thickness to 1px for a clean and defined border that enhances visibility without overwhelming the design. Adjust as needed based on your personal preference and the overall aesthetics of your theme.
              squareCorners = true; # Set to true to make all corners square, overriding gothCornersEnabled for a more classic look

              fontScale = 1.5; # Increase font scale for better readability and a more impactful visual presence on the bar. Adjust as needed based on your screen resolution and personal preference.
              iconScale = 1.5; # Increase icon scale to match the larger font size and create a more cohesive look on the bar. Adjust as needed based on your widget sizes and personal preference.

              network_click_action = "applet";
              audio_click_action = "applet";

              leftWidgets = [
                "launcherButton"
                "workspaceSwitcher"
                "focusedWindow"
              ];
              centerWidgets = [
                "clock"
              ];
              rightWidgets = [
                "weather"
                "systemTray"
                "cpuUsage"
                "memUsage"
                "cpuTemp"
                "gpuTemp"
                "controlCenterButton"
                "notificationButton"
              ];
            }
          ];

          widgets = {
            workspace_switcher = {
              show_labels = false;
              indicator_style = "pill";
            };
          };
        };
      }
    )
  ];
}
