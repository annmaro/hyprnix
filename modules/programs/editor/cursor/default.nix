{
  pkgs,
  inputs,
  ...
}:
{
  home-manager.sharedModules = [
    (
        home.packages = [
    inputs.cursor.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
)
];
}
