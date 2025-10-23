{

systemd.tmpfiles.rules = 

let
  user = "annmaro";
  iconPath = ./kitten.png;
in [
  "f+ /var/lib/AccountsService/users/${user}  0600 root root -  [User]\\nIcon=/var/lib/AccountsService/icons/${user}\\n"
  "L+ /var/lib/AccountsService/icons/${user}  -    -    -    -  ${iconPath}"
];
}