{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ spoofdpi ];

  systemd.services.spoofdpi = {
    description = "SpoofDPI daemon to bypass SNI filtering";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.spoofdpi}/bin/spoofdpi -addr 127.0.0.1 -port 8080 -enable-doh";
      Restart = "always";
      RestartSec = "5";
      DynamicUser = true;
    };
  };
}
