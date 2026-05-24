{ inputs, pkgs, ... }:

{

  # ADD THIS BLOCK RIGHT HERE:
  systemd.user.systemctlPath = "${pkgs.systemd}/bin/systemctl";
  
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  home-manager.sharedModules = [
    (
      { config, ... }: 
      
      {
        
        imports = [
          inputs.sops-nix.homeManagerModules.sops
        ];

        # --- PACKAGES ---
        home.packages = [ 
          pkgs.sops
          pkgs.gnupg 
          pkgs.skim   
          pkgs.peco   
        ];

        # --- SOPS SECRETS SYSTEM ---
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
            "gemini_api_key" = {};
          };
        };

        # --- GPG AGENT TERMINAL CONFIGURATION ---
        services.gpg-agent = {
          enable = true;
          pinentry.package = pkgs.pinentry-curses;
          defaultCacheTtl = 3600; 
          # Allows loopback background connections to read your passphrase from TTY
          extraConfig = ''
            allow-loopback-pinentry
          '';
        };

        # --- GIT SERVICE & ALIASES ---
        programs.git = {
          enable = true;

          lfs = {
            enable = true;
            skipSmudge = true; 
          };

          signing = {
            # Fixed Scope: Dynamically matches the sops secret placeholder declared above
            key = config.sops.placeholder."git_key_id"; 
            signByDefault = true;
          };

          ignores = [
            "*.o" "*.out" "*.result" "result" ".env" "*.env" ".DS_Store" "Thumbs.db" "*~" "*.swp"       
          ];

          # Global configurations mapped directly to your .gitconfig file
          settings = {
            user.name = "annmaro";
            user.email = "anandk60440@gmail.com";

            alias = {
              essa = "push --force";
              co = "checkout";
              fuck = "commit --amend -m";
              c = "commit -m";
              ca = "commit -am";
              forgor = "commit --amend --no-edit";
              graph = "log --all --decorate --graph --oneline";
              oops = "checkout --";
              l = "log";
              r = "rebase";
              s = "status --short";
              ss = "status";
              d = "diff";
              st = "status";
              br = "branch";
              ps = "!git push origin $(git rev-parse --abbrev-ref HEAD)";
              pl = "!git pull origin $(git rev-parse --abbrev-ref HEAD)";
              af = "!git add $(git ls-files -m -o --exclude-standard | sk -m)";
              df = "!git hist | peco | awk '{print $2}' | xargs -I {} git diff {}^ {}";
              hist = ''
                log --pretty=format:"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)" --graph --date=relative --decorate --all'';
              llog = ''
                log --graph --name-status --pretty=format:"%C(red)%h %C(reset)(%cd) %C(green)%an %Creset%s %C(yellow)%d%Creset" --date=relative'';
              edit-unmerged = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; hx `f`";
            };

            gpg = {
              program = "${pkgs.gnupg}/bin/gpg";
            };
            commit = {
              gpgsign = true;
            };
            init = {
              defaultBranch = "main";
            };
            push = {
              autoSetupRemote = true;
            };
            lfs = {
              pruneoffset = "30";
            };
          };
        };
      }
    )
  ];
}