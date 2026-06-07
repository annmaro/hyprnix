{ self, host, ... }:
{

  systemd.tmpfiles.rules =

    let
      inherit (import "${self}/hosts/${host}/variables.nix") username;
      user = "${username}";
      iconPath = ./nix.png;
    in
    [
      "f+ /var/lib/AccountsService/users/${user}  0600 root root -  [User]\\nIcon=/var/lib/AccountsService/icons/${user}\\n"
      "L+ /var/lib/AccountsService/icons/${user}  -    -    -    -  ${iconPath}"
    ];
}
