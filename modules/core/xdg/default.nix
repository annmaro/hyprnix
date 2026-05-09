 {
 # XDG MIME type associations
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Directories and file managers
      "inode/directory" = [
        "yazi.desktop"
        "thunar.desktop"
      ];
      "inode/blockdevice" = ["thunar.desktop"];

      # Images - qView
     /* "image/bmp" = ["com.interversehq.qView.desktop"];
      "image/gif" = ["com.interversehq.qView.desktop"];
      "image/jpeg" = ["com.interversehq.qView.desktop"];
      "image/jpg" = ["com.interversehq.qView.desktop"];
      "image/png" = ["com.interversehq.qView.desktop"];
      "image/svg+xml" = ["com.interversehq.qView.desktop"];
      "image/tiff" = ["com.interversehq.qView.desktop"];
      "image/webp" = ["com.interversehq.qView.desktop"];
     */
      # Videos - VLC
      "video/mp4" = ["vlc.desktop"];
      "video/mpeg" = ["vlc.desktop"];
      "video/quicktime" = ["vlc.desktop"];
      "video/webm" = ["vlc.desktop"];
      "video/x-matroska" = ["vlc.desktop"];
      "video/x-msvideo" = ["vlc.desktop"];

      # Audio - VLC
    /*  "audio/aac" = ["vlc.desktop"];
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
      # Web - Brave
      "text/html" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];

      # Terminal
      "application/x-terminal-emulator" = ["kitty.desktop"];
      "x-scheme-handler/terminal" = ["kitty.desktop"];

      # Torrents - Transmission
      "x-scheme-handler/magnet" = ["qbittorrent.desktop"];
      "application/x-bittorrent" = ["qbittorrent.desktop"];
    };
  };
 }  

     