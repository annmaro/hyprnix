{ config, pkgs, lib, ... }:

{
  home.packages = [ pkgs.rmpd ];

  xdg.configFile."rmpd/rmpd.toml".text = ''
    [general]
    music_directory = "~/Music"
    log_level = "info"

    [network]
    port = 6600

    [audio]
    default_output = "pipewire"
    replay_gain = "off"

    [[output]]
    name = "PipeWire Sound Server"
    type = "pipewire"
    # To support high res / lossless, let PipeWire handle format natively
    # And disable internal resampling if rmpd has it
    resampler_quality = 0
  '';

  systemd.user.services.rmpd = {
    Unit = {
      Description = "rmpd - Rust Music Player Daemon";
      After = [ "network.target" "pipewire.service" ];
    };
    Service = {
      ExecStart = "${pkgs.rmpd}/bin/rmpd";
      Restart = "always";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
