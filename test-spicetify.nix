let
  flake = builtins.getFlake "github:Gerg-L/spicetify-nix/c679f3fa9fbe86903486a8f7ad71f99e26481d71";
  spicePkgs = flake.legacyPackages.x86_64-linux;
in
builtins.attrNames spicePkgs
