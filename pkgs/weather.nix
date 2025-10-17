{ stdenv
, fetchFromGitLab
,
}: {
    waybar-weather = stdenv.mkDerivation rec {
        pname = "waybar-weather";
        version = 