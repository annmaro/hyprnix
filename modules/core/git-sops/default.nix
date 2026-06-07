{ self, host, config, inputs, pkgs, ... }: 
let
  inherit (import "${self}/hosts/${host}/variables.nix") username;
in
{
  home-manager.users.${username} = { config, pkgs, ... }: 

 {  

  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./git.nix 
  ];

  home.packages = [
    pkgs.sops
  ];

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ../../../secrets/secrets.yaml; 
    defaultSopsFormat = "yaml";
    
    secrets = {
      "private_ssh_key" = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
        mode = "0600";
      };
      "rclone_gdrive_env" = {};
      "git_email" = {};  
      "git_key_id" = {}; 
      "gemini_api_key" = {};
    };
  };
};
}
