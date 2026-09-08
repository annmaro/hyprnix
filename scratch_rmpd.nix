let
  pkgs = import <nixpkgs> {};
in
pkgs.rustPlatform.buildRustPackage rec {
  pname = "rmpd";
  version = "0.7.0";
  src = pkgs.fetchFromGitHub {
    owner = "M0Rf30";
    repo = "rmpd";
    rev = "0.7.0";
    sha256 = "0czd9l0c0m0q6hbi4bnk8idjjfahpn3bccrs6hw7kscra0zh3x6z";
  };
  cargoHash = pkgs.lib.fakeHash;
}
