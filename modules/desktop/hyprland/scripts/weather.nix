{ stdenv
, fetchFromGitLab
,
}: {

    weather = stdenv.mkDerivation rec {
    pname = "waybar-weather";
    version = "240eec32fae25ab756dda2330fb24b3e97d55aa8";

    src = fetchFromGitLab {
      owner = "BaconIsAVeg";
      repo = "waybar-weather";
      rev = "${version}";
      sha256 = "7a898d4efa547e26ca86e511bb3140cf70d443ad";
    }; 

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/share/waybar/waybar-weather
      cp -r $src/* $out/share/waybar/waybar-weather/
      chmod -R +w $out/share/waybar/waybar-weather
      '';
  };
}
