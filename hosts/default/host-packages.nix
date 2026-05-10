{ pkgs,  ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    proton-vpn # VPN
    # github-desktop
    pokego # Overlayed
    waybar-weather # FIXED: Ensure waybar-weather is available at system level
  ];
}
