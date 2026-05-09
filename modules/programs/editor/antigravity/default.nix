{
  pkgs,
  inputs,
  ...
}:
{
home-manager.sharedModules = [
    (_: {
      imports = [antigravity-nix.packages.${system}.google-antigravity-no-fhs];
    }
    )
];
}  