# This file is for those who want to add more users to their system. By default, the configuration creates a user named "anand" with sudo privileges. If you want to add more users, simply add their usernames to the `allowed-users` list and define their attributes in the `home-manager.users` and `users.users` sections.

{
  self,
  pkgs,
  inputs,
  host,
  ...
}:
let
  inherit (import "${self}/hosts/${host}/variables.nix")
    username
    editor
    terminal
    browser
    shell
    ;

  userGroups = [
    "wheel"
    "input"
    "networkmanager"
    "video"
    "audio"
    "libvirtd"
    "kvm"
    "docker"
    "disk"
    "adbusers"
    "lp"
    "scanner"
    "vboxusers"
  ];

  sessionVariablesFor = editorArg: {
    EDITOR =
      if (editorArg == "nixvim" || editorArg == "neovim" || editorArg == "nvchad") then
        "nvim"
      else if editorArg == "vscode" then
        "code"
      else
        "nano";
    BROWSER = browser;
    TERMINAL = terminal;
  };

  homeAttrs = userName: editorArg: {
    programs.home-manager.enable = true;
    xdg.enable = true;
    home = {
      username = userName;
      homeDirectory = "/home/${userName}";
      stateVersion = "26.05";
      sessionVariables = sessionVariablesFor editorArg;
      enableNixpkgsReleaseCheck = false;
    };

  };

  userAttrs = userName: {
    isNormalUser = true;
    extraGroups = userGroups;
    shell = pkgs.${shell};
    ignoreShellProgramCheck = true;
  };

in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  programs.dconf.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  nix.settings.allowed-users = if username == "anand" then [ "anand" ] else [ "${username}" "anand" ];

  home-manager.users = if username == "anand"
    then {
      "${username}" = homeAttrs username editor;
    }
    else {
      "${username}" = homeAttrs username editor;
      anand = homeAttrs "anand" "vscode";
    };

  users = {
    mutableUsers = true;
    users = if username == "anand"
      then {
        "${username}" = userAttrs username;
      }
      else {
        "${username}" = userAttrs username;
        anand = userAttrs "anand";
      };
  };
}
