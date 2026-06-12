{ pkgs, ... }:
{
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin # Archive management
      thunar-volman # Volume management (automount removable devices)
      thunar-media-tags-plugin # Tagging & renaming feature for media files
    ];
  };
  # Archive manager
  environment.systemPackages = with pkgs; [ file-roller ];
  # Fix for Thunar "Open Terminal Here"
  # Replace 'kitty' with the actual command of your terminal!
  /*
    Open Thunar.

        In the top menu bar, go to Edit -> Configure custom actions...

        Look for the default Open Terminal Here action and click the Edit (pencil) icon.

        Change the text in the Command: box to:

    footclient --directory %f

        Click OK to save the changes and close the dialog.

        Now, when you right-click in Thunar and select "Open Terminal Here," it should open your terminal emulator in the current directory.
  */
}
