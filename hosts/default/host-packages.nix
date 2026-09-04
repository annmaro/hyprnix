{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    proton-vpn # VPN
    # github-desktop
    pokego # Overlayed
    inputs.readest.packages.${pkgs.system}.default
   # waybar-weather # Waybar Weather Module
];
}
