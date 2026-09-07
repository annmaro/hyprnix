{ inputs, pkgs, ... }: {
  imports = [
    inputs.noctalia.nixosModules.default
  ];

  programs.noctalia = {
    enable = true;
    
    # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
    recommendedServices.enable = true;
  };

  # If they also want systemd user services for noctalia:
  # programs.noctalia.systemd.enable = true;
}
