
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
  
    home-manager.users.${username} = {
      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      xdg.enable = true;
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "25.05"; # Do not change!
        sessionVariables = {
          EDITOR =
            if (editor == "nixvim" || editor == "neovim" || editor == "nvchad") then
              "nvim"
            else if editor == "vscode" then
              "code"
            else
              "nano";
          BROWSER = "${browser}";
          TERMINAL = "${terminal}";
        };
      };
    };
  
  users = {
    mutableUsers = true;
    users.${username} = {
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
