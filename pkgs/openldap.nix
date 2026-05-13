{ config, pkgs, ... }:

{
  # Add the overlay
  nixpkgs.overlays = [
    (final: prev: {
      openldap = prev.openldap.overrideAttrs {
        doCheck = !prev.stdenv.hostPlatform.isi686;
      };
    })
  ];

}