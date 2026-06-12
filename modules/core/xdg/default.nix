{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        # --- NEW: xdg-user-dirs configuration ---
        xdg.userDirs = {
          enable = true;
          createDirectories = true;

          # Optional: You can explicitly set paths here if you want to override the defaults.
          # For example, if you wanted a custom name for the Downloads folder:
          # download = "${config.home.homeDirectory}/Downloads";
        };

        xdg.mimeApps = {
          enable = true;
          defaultApplications = {
            # Directories and file managers
            "inode/directory" = [
              "yazi.desktop"
              "thunar.desktop"
            ];
            "inode/blockdevice" = [ "thunar.desktop" ];

            # Images - nomacs
            "image/bmp" = [ "org.nomacs.ImageLounge.desktop" ];
            "image/gif" = [ "org.nomacs.ImageLounge.desktop" ];
            "image/jpeg" = [ "org.nomacs.ImageLounge.desktop" ];
            "image/jpg" = [ "org.nomacs.ImageLounge.desktop" ];
            "image/png" = [ "org.nomacs.ImageLounge.desktop" ];
            "image/svg+xml" = [ "org.nomacs.ImageLounge.desktop" ];
            "image/tiff" = [ "org.nomacs.ImageLounge.desktop" ];
            "image/webp" = [ "org.nomacs.ImageLounge.desktop" ];

            # Videos - celluloid
            "video/mp4" = [ "io.github.celluloid_player.Celluloid.desktop" ];
            "video/mpeg" = [ "io.github.celluloid_player.Celluloid.desktop" ];
            "video/quicktime" = [ "io.github.celluloid_player.Celluloid.desktop" ];
            "video/webm" = [ "io.github.celluloid_player.Celluloid.desktop" ];
            "video/x-matroska" = [ "io.github.celluloid_player.Celluloid.desktop" ];
            "video/x-msvideo" = [ "io.github.celluloid_player.Celluloid.desktop" ];

            # Audio - VLC
            /*
              "audio/aac" = ["vlc.desktop"];
              "audio/flac" = ["vlc.desktop"];
              "audio/mp3" = ["vlc.desktop"];
              "audio/mpeg" = ["vlc.desktop"];
              "audio/ogg" = ["vlc.desktop"];
              "audio/wav" = ["vlc.desktop"];
              "audio/webm" = ["vlc.desktop"];
              "audio/x-opus+ogg" = ["vlc.desktop"];
              "audio/x-vorbis+ogg" = ["vlc.desktop"];
              "audio/x-mpegurl" = ["vlc.desktop"];
              "audio/mpegurl" = ["vlc.desktop"];
              "application/vnd.apple.mpegurl" = ["vlc.desktop"];
              "application/x-mpegurl" = ["vlc.desktop"];

              # Documents
              "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];

              # Text and code files
              "text/plain" = ["dev.zed.Zed.desktop"];
              "text/markdown" = ["dev.zed.Zed.desktop"];
              "text/x-csrc" = ["dev.zed.Zed.desktop"];
              "text/x-python" = ["dev.zed.Zed.desktop"];
              "application/x-shellscript" = ["dev.zed.Zed.desktop"];

              # Archives - File Roller
              "application/zip" = ["org.gnome.FileRoller.desktop"];
              "application/x-7z-compressed" = ["org.gnome.FileRoller.desktop"];
              "application/x-rar" = ["org.gnome.FileRoller.desktop"];
              "application/x-tar" = ["org.gnome.FileRoller.desktop"];
              "application/gzip" = ["org.gnome.FileRoller.desktop"];
            */

            # Web - firefox
            "text/html" = [ "firefox.desktop" ];
            "x-scheme-handler/http" = [ "firefox.desktop" ];
            "x-scheme-handler/https" = [ "firefox.desktop" ];

            # Antigravity Auth Handler
            "x-scheme-handler/antigravity" = [ "antigravity.desktop" ];

            # Terminal
            "application/x-terminal-emulator" = [ "footclient.desktop" ];
            "x-scheme-handler/terminal" = [ "footclient.desktop" ];

            # Torrents - Transmission
            "x-scheme-handler/magnet" = [ "qbittorrent.desktop" ];
            "application/x-bittorrent" = [ "qbittorrent.desktop" ];
          };
        };
      }
    )
  ];
}
