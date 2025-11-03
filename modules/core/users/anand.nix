
{
  pkgs,
  inputs,
  host,
  ...
}:
let
  inherit (import ../../../hosts/${host}/variables.nix)
    username
    editor
    terminal
    browser
    shell
    ;
in
{

    home-manager.users.anand = {
      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      xdg.enable = true;
      home = {
        username = "anand";
        homeDirectory = "/home/anand";
        stateVersion = "25.05"; # Do not change!
        sessionVariables = {
          EDITOR = "vscode"; 
          BROWSER = "${browser}";
          TERMINAL = "${terminal}";
        };
      };
    };
  
  users = {
    users.anand = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # sudo access
        "input"
        "networkmanager"
        "video"
        "audio"
        "libvirtd" #Virt manager/QEMU access
        "kvm"
        "docker" #access to docker as non-root
        "disk"
        "adbusers"
        "lp"
        "scanner"
        "vboxusers" # Virtual Box
      ];
      shell = pkgs.${shell};
      ignoreShellProgramCheck = true;
    };
  };
}
