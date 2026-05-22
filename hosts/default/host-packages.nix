{ pkgs,  ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    proton-vpn # VPN
    # github-desktop
    pokego # Overlayed
   # waybar-weather # Waybar Weather Module
];
}
