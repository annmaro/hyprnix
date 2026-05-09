{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    proton-vpn # VPN
    inputs.cursor.packages.${pkgs.stdenv.hostPlatform.system}.default # AI-powered code editor built on vscode
    # github-desktop
     pokego # Overlayed
  ];
}
