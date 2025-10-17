{ host, pkgs, ... }:
let
  inherit (import ../../../hosts/${host}/variables.nix) username;
in
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 2d --keep 2";
    };
    flake = "/home/${username}/hyprnix";
  };

   environment.systemPackages = with pkgs; [
     nix-output-monitor
     nvd
   ];
}
