{ self, host, ... }:
let
  inherit (import "${self}/hosts/${host}/variables.nix") username;
in
{
  services.syncthing = {
    enable = true;
    user = "${username}";
    dataDir = "/home/${username}";
    configDir = "/home/${username}/.config/syncthing";
  };
}
