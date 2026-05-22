{ host, pkgs, ... }:
{
  # these will be overlayed in nixpkgs automatically.
  # for example: environment.systemPackages = with pkgs; [pokego];
  pokego = pkgs.callPackage ./pokego.nix { };
  # waybar-weather = pkgs.callPackage ./waybar-weather.nix { };
  
}
