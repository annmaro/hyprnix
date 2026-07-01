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

  # Manually bypass the host-level block for these platforms
  networking.extraHosts = ''

    127.0.0.1 pixeldrain.com
    127.0.0.1 www.pixeldrain.com

    127.0.0.1 terabox.com
    127.0.0.1 www.terabox.com
    127.0.0.1 teraboxapp.com
    127.0.0.1 www.teraboxapp.com
  '';
}
