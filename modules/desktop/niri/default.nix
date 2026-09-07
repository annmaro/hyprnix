{ self, host, ... }@args:
let
  vars = import "${self}/hosts/${host}/variables.nix";
in
{
  imports = [
    (if vars.bar == "noctalia" then ./noctalia_niri.nix else ./dms_niri.nix)
  ];
}
