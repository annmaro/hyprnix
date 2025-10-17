{ pkgs, ... }:
{
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.hyprland.enableGnomeKeyring = true;
    pam.services.sddm.enableGnomeKeyring = true;
    sudo.extraConfig =
    "Defaults pwfeedback"; # Show asterisks when typing sudo password
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
      packages = [ pkgs.apparmor-profiles ];
    };
  };
}
