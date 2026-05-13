{ pkgs,  ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    proton-vpn # VPN
    # github-desktop
    pokego # Overlayed
    waybar-weather # Waybar Weather Module
    openldap # OpenLDAP with doCheck disabled on i686 (see pkgs/openldap.nix)
  ];
}
