{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  # Import the custom theme module directly into a Nix variable
  amoledBlackTheme = import ./dms_theme.nix { inherit pkgs lib; };
in
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {

        imports = [
          inputs.dms.homeModules.dank-material-shell
          inputs.dms.homeModules.niri # Enforce native Niri features & auto-spawning
          #./logo.nix # Custom system logo plugin with inline QML for better performance and easier management
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
        # This handles writing out your theme.json using the file we imported above
        xdg.configFile."DankMaterialShell/themes/amoledBlack/theme.json".text =
          builtins.toJSON amoledBlackTheme;

        # =====================================================================
        # 🎨 SETTINGS.JSON CONFIGURATION
        # =====================================================================
        xdg.configFile."DankMaterialShell/settings.json".text = builtins.toJSON {
          configVersion = 2;
          disableWallpaper = false; # Set true if you want to handle wallpaper through swaybg/awww

          modules = {
            bar = true;
            notifications = true;
            idle = true;
            lockscreen = true;
            wallpaper = true; # false to keep it managed by your separate awww/swaybg
            launcher = false; # Handled by your native rofi setup
            dock = false;
          };

          dynamicTheming = false; # Disable dynamic theming to maintain a consistent look across all widgets, regardless of the current wallpaper or system theme. This ensures that your custom color choices are always applied.
          currentThemeName = "custom"; # Use "custom" to apply your custom theme file specified below
          customThemeFile = "${config.home.homeDirectory}/.config/DankMaterialShell/themes/amoledBlack/theme.json"; # Path to your custom theme file for consistent theming across all DMS widgets. Make sure this file exists and contains your desired color settings.

          profileImage = "${config.home.homeDirectory}/.config/DankMaterialShell/nix.png"; # Set the path to your profile image for display in the overview and other DMS components. Make sure the image exists at this location and is in a supported format (e.g., PNG, JPEG).

          widgetBackgroundColor = "s"; # Use DMS's color tokens for consistent theming
          widgetColorMode = "colorful"; # "colorful" to use theme colors, "default" for a more neutral look
          buttonColorMode = "primary"; # Use primary color for buttons

          popupTransparency = 0.40; # Set popup transparency to create a frosted glass effect for notifications and other popups, allowing the wallpaper to subtly show through while keeping the content readable. Adjust as needed for your preferred balance of visibility and aesthetics.
          cornerRadius = 16; # Apply a consistent border radius to all widgets for a cohesive look

          blurEnabled = true; # Enable blur for overview and other popups
          blurWallpaperOnOverview = true; # Blur the wallpaper when opening the overview for better focus on windows
          blurForegroundLayers = false; # Only blur the background for a cleaner look

          weatherEnabled = true;
          weatherLocation = "Ramgarh, Jharkhand, India";
          weatherCoordinates = "23.5987759,85.5369156";
          useFahrenheit = false;
          useLocation = false; # Set to true to allow DMS to auto-detect location for weather. If false, it will use the specified location above.

          barConfigs = [
            {
              id = "default";
              name = "Main Bar";
              enabled = true;
              position = "top";
              spacing = 0; # Space between the bar and screen edges

              # Setting bar transparency to 0 hides the background bar background,
              # allowing only the styled widgets to display as floating pill capsules.
              transparency = 0.70; # Adjust bar transparency to your liking (0 = fully transparent, 1 = fully opaque). A value around 0.7 can create a nice frosted glass effect while still allowing the wallpaper to subtly show through behind the widgets.
              widgetTransparency = 1; # Set widget transparency to 1 for fully opaque widgets that stand out against the transparent bar background

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
                "systemLogo"
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
                "controlCenterButton"
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
