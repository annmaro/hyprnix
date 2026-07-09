{
  config,
  lib,
  inputs,
  ...
}:

{
  imports = [
    inputs.stevenblack-hosts.nixosModule
    ./privoxy.nix
  ];

  # This configures the StevenBlack hosts adblocker module.
  networking.stevenBlackHosts = {
    enable = true;

    # We explicitly disable the social media category
    blockSocial = false;

    # You can choose to enable other optional categories:
    blockFakenews = false;
    blockGambling = false;
    blockPorn = false;
  };


}
