{
  pkgs,
  lib,
  self,
  host,
  ...
}:
let
  inherit (import "${self}/hosts/${host}/variables.nix") username;
in
{


  # Graphics Configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # System-wide packages
  environment.systemPackages = with pkgs; [
    stable.lutris
    heroic
    # bottles
    # ryujinx
    # prismlauncher

    steam-run
    wineWow64Packages.staging
  ];

  # User groups configuration
  users.users.${username}.extraGroups = [ "gamemode" ];

  # Programs & Gaming Configurations
  programs = {
    # Integrated GameMode with custom hooks and optimizations
    gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;                # Sets nice priority of the game to -10 (high priority)
          ioprio = 0;                 # Gives games the highest I/O scheduling priority
          inhibit_screensaver = 1;    # Stops screensavers or monitors turning off while playing
        };

        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations activated. Performance governor engaged.'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations deactivated. Balanced governor restored.'";
        };

        # Optional GPU Optimizations (Uncomment if using a dedicated graphics card)
        # gpu = {
        #   apply_gpu_optimisations = "accept-responsibility";
        #   gpu_vendor = "amd"; # Choose: amd or nvidia
        #   amd_performance_level = "high";
        #   nv_core_clock_mhz_offset = 100;
        #   nv_mem_clock_mhz_offset = 100;
        # };
      };
    };

    # Steam configuration
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    # Gamescope configuration
    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };
  };

  # MangoHud configuration via Home Manager shared modules
  home-manager.sharedModules = [
    (_: {
      programs.mangohud = {
        enable = true;
        enableSessionWide = true;
        settingsPerApplication = {
          mpv = {
            no_display = true;
          };
        };
        settings = {
          no_display = true; # Hide hud by default (Show by holding right-shift then press F12)
          fps_limit = [
            60
            0
            144
            165
            240
          ];
          fps_limit_method = "late"; # late = low input lag but less smooth, early = more smooth
          vsync = 2; # https://github.com/flightlessmango/MangoHud#vsync
          gl_vsync = 1; # https://github.com/flightlessmango/MangoHud#vsync

          # Keybinds
          toggle_hud = "Shift_R+F12";
          # toggle_hud_position="Shift_R+F11";
          toggle_fps_limit = "Shift_R+F1";
          # toggle_logging="Shift_L+F2";
          # reload_cfg="Shift_L+F4";
          # upload_log="Shift_L+F3";

          # SYSTEM
          fps = true;
          show_fps_limit = true;
          frametime = true;
          frame_timing = true;
          present_mode = true;
          core_load = false;
          ram = true;
          # swap
          # core_load_change

          # CPU
          cpu_stats = true;
          cpu_temp = true;
          cpu_power = true;
          cpu_text = "CPU";
          cpu_mhz = true;

          # GPU
          throttling_status = true;
          gpu_stats = true;
          gpu_temp = true;
          gpu_core_clock = true;
          gpu_mem_clock = true;
          gpu_power = true;
          gpu_text = "GPU";
          vram = true;
          # gpu_load_change
          # gpu_load_value=60,90
          # gpu_load_color=39F900,FDFD09,B22222
        };
      };
    })
  ];
}