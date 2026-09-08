{ config, pkgs, lib, ... }:

let
  rmpd = pkgs.stdenv.mkDerivation rec {
    pname = "rmpd";
    version = "0.7.0";

    src = pkgs.fetchurl {
      url = "https://github.com/M0Rf30/rmpd/releases/download/${version}/rmpd-${version}-x86_64-unknown-linux-gnu.tar.gz";
      sha256 = "1q21qiikv8smiz7ppz2462nwd60s1hr09rm0wskkgyff9nqx0phm";
    };

    sourceRoot = ".";

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ 
      pkgs.alsa-lib 
      pkgs.chromaprint 
      pkgs.gcc.cc.lib 
      pkgs.glibc 
      pkgs.dbus
    ];

    installPhase = ''
      mkdir -p $out/bin
      cp rmpd $out/bin/
      chmod +x $out/bin/rmpd
    '';
  };
in
{
  home-manager.sharedModules = [
    (_: {
      home.packages = [ rmpd ];

      xdg.configFile."rmpd/rmpd.toml".text = ''
        [general]
        music_directory = "~/Music"
        log_level = "info"

        [network]
        port = 6600
        mpris = true

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
          ExecStart = "${rmpd}/bin/rmpd";
          Restart = "always";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    })
  ];
}
