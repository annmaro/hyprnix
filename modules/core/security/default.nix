{ pkgs, ... }:
{
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.lightdm.enableGnomeKeyring = true;
    sudo.extraConfig =
    "Defaults pwfeedback"; # Show asterisks when typing sudo password
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
      packages = [ pkgs.apparmor-profiles ];
    };
  };
}
