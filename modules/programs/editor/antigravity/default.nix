{
  pkgs,
  inputs,
  ...
}:
{
  home-manager.sharedModules = [
    (
        home.packages = [
        inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-no-fhs
        ];       
)
];
}  