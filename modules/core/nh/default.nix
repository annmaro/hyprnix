{ self, host, pkgs, ... }:
let
  inherit (import "${self}/hosts/${host}/variables.nix") username;
in
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 2d --keep 2";
    };
    flake = "/home/${username}/nixri";
  };

   environment.systemPackages = with pkgs; [
     nix-output-monitor
     nvd
   ];
}
