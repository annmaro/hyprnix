{ pkgs, ... }:

{
  home-manager.sharedModules = [
    (
      { ... }: {
      
      home.packages = [ 
        pkgs.gnupg 
        pkgs.skim   # Required package for the 'git af' fuzzy finder alias
        pkgs.peco   # Required package for the 'git df' terminal selector alias
      ];

      services.gpg-agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-gnome3; 
        defaultCacheTtl = 3600; 
      };

      programs.git = {
        enable = true;
        userName = "annmaro";
        # Dynamically absorbs the hidden decrypted email address
        userEmail = config.sops.secrets."git_email".path;

        # Enable Git LFS and activate the skip smudge optimization globally
        lfs = {
          enable = true;
          skipSmudge = true; 
        };

        signing = {
          # Dynamically absorbs the hidden decrypted GPG fingerprinted hash
          key = config.sops.secrets."git_key_id".path; 
          signByDefault = true;
        };

        # Merged Custom Git Aliases Block
        aliases = {
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

        # Declarative Global Git Ignore Array
        ignores = [
          "*.o"
          "*.out"
          "*.result"
          "result"      
          ".env"
          "*.env"
          ".DS_Store"   
          "Thumbs.db"   
          "*~"          
          "*.swp"       
        ];

        extraConfig = {
          gpg.program = "${pkgs.gnupg}/bin/gpg";
          commit.gpgsign = true;
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
          # --- AUTOMATED LFS PRUNING CONFIGURATION ---
          # Automatically deletes cached large files older than 30 days
          lfs.pruneoffset = "30";
        };
      };
    })
  ];
}
