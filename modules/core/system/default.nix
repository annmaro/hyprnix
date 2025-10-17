{
  self,
  inputs,
  outputs,
  host,
  pkgs,
  overlays,
  ...
}:
let
  inherit (import ../../../hosts/${host}/variables.nix)
    consoleKeymap
    kbdLayout
    kbdVariant
    ;
in
{
  imports = [ inputs.nix-index-database.nixosModules.nix-index ];
  programs = {
    nix-index-database.comma.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
  services.xserver = {
    enable = true;
    exportConfiguration = true; # Make sure /etc/X11/xkb is populated so localectl works correctly
    xkb = {
      layout = "${kbdLayout}";
      variant = "${kbdVariant}";
    };
  };
  nix = {
    # Nix Package Manager Settings
    settings = {
      download-buffer-size = 200000000;
      auto-optimise-store = true; # May make rebuilds longer but less size
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org/"
        "https://chaotic-nyx.cachix.org/"
        "https://cachix.cachix.org"
        "https://nix-gaming.cachix.org/"
        "https://hyprland.cachix.org"
        # "https://nixpkgs-wayland.cachix.org"
        # "https://devenv.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        # "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        # "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      use-xdg-base-directories = false;
      warn-dirty = false;
      keep-outputs = true;
      keep-derivations = true;
    };
    optimise.automatic = true;
    package = pkgs.nixVersions.latest;
  };
  time.timeZone = "Asia/Kolkata";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "en_IN/UTF-8"
      "C.UTF-8/UTF-8"
    ];
  extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };
  };
  environment.variables = {
    NIXOS_OZONE_WL = "1";

    # These are the defaults, and xdg.enable does set them, but due to load
    # order, they're not set before environment.variables are set, which could
    # cause race conditions.
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_BIN_HOME = "$HOME/.local/bin";
    XDG_RUNTIME_DIR = "/run/user/$UID";
  };

  console.keyMap = "${consoleKeymap}";
  nixpkgs = {
    overlays = builtins.attrValues overlays;
    config = {
      allowUnfree = true;
      # allowUnfreePredicate = _: true;
    };
  };
  system.stateVersion = "25.05"; # Do not change!
}
