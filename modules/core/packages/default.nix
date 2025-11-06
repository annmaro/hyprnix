{ pkgs, ... }:

{

 # TODO: review
  programs = {
    fuse.userAllowOther = true;
    mtr.enable = true;
    adb.enable = true;
    hyprlock.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
 

  environment.systemPackages = with pkgs; [
    appimage-run # Needed For AppImage Support
    killall # For Killing All Instances Of Programs
    lm_sensors # Used For Getting Hardware Temps
    gnome-disk-utility # Disk Partitioning and Mounting Utility
    jq # Json Formatting Utility
    libsecret # Library for storing and retrieving passwords and other secrets
    seahorse # Application for managing encryption keys and passwords in the GnomeKeyring
    bibata-cursors
    fzf # Fuzzy Finder
    fd # Better Find
    libjxl # Support for JXL Images
    microfetch # Small fetch (Blazingly fast)
    nix-prefetch-scripts # Find Hashes/Revisions of Nix Packages
    ripgrep # Improved Grep
    tldr # Improved Man
    rimgo # Alternative frontend for Imgurss
    unrar # Tool For Handling .rar Files
    unzip # Tool For Handling .zip Files
    vlc # Cross-platform media player and streaming server
    peazip # File and archive manager
    calibre # Comprehensive e-book software
    vivaldi # Browser for our Friends, powerful and personal
    foliate # Simple and modern GTK eBook reader
    nicotine-plus # Graphical client for the SoulSeek peer-to-peer system
    uget # Download manager using GTK and libcurls
    easyeffects # Audio effects for PipeWire applications
    pay-respects # Magnificent app which corrects your previous console command
    nix-tree # Interactively browse a Nix store paths dependencies
    imagemagickBig # Software suite to create, edit, compose, or convert bitmap images
    digikam # Photo management application
    quodlibet-full # GTK-based audio player written in Python, using the Mutagen tagging library
    papers # GNOME's document viewer
    libreoffice-fresh # Comprehensive, professional-quality productivity suite
    # aider-chat # AI in terminal (Optional: Client only)
    # cmatrix # Matrix Movie Effect In Terminal
    # cowsay # Great Fun Terminal Program
    # duf # Utility For Viewing Disk Usage In Terminal
    # dysk # Disk space util nice formattting
    # ffmpeg # Terminal Video / Audio Editing
    # gemini-cli # CLI AI client ONLY (optional)
    # glxinfo # needed for inxi diag util
     inxi # CLI System Information Tool
    # libsForQt5.qt5.qtgraphicaleffects # Sddm Dependency (Old)
    # libnotify # For Notifications
    # lolcat # Add Colors To Your Terminal Command Output
     lshw # Detailed Hardware Information
    # mpv # Incredible Video Player
     ncdu # Disk Usage Analyzer With Ncurses Interface
     nixfmt-rfc-style # Nix Formatter
    # nwg-displays # configure monitor configs via GUI
    # onefetch # provides zsaneyos build info on current system
    # pavucontrol # For Editing Audio Levels & Devices
    # pciutils # Collection Of Tools For Inspecting PCI Devices
    # picard # For Changing Music Metadata & Getting Cover Art
    # pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
    # socat # Needed For Screenshots
     usbutils # Good Tools For USB Devices
    # uwsm # Universal Wayland Session Manager (optional must be enabled)
    # v4l-utils # Used For Things Like OBS Virtual Camera
    # warp-terminal # Terminal with AI support build in
     wget # Tool For Fetching Files With Links
   
    # devenv
    # devbox
    # shellify
  ];
}
