{ inputs, ... }:

{
  home-manager.sharedModules = [
    ({ config, ... }: {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
      ];

      sops = {
        age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
        # Resolves automatically relative to your Flake repository folder root
        defaultSopsFile = ../../../secrets/secrets.yaml; 
        defaultSopsFormat = "yaml";
        
        secrets = {
          "private_ssh_key" = {
            path = "${config.home.homeDirectory}/.ssh/id_ed25519";
            mode = "0600";
          };
          "rclone_gdrive_env" = {};
          "git_email" = {};  # <-- Tracked smoothly in volatile memory
          "git_key_id" = {}; # <-- Tracked smoothly in volatile memory
        };
      };
    })
  ];
}
