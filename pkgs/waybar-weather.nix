{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "waybar-weather";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "wneessen";
    repo = "waybar-weather";
    rev = "v${version}";
    hash = "sha256-I2g8TFsSN4y+QQ+cKVB2ea6TRgbhskIX7q3hCSnMpUs=";
  };

  vendorHash = "sha256-QdT0vKnCO+7DezbH8NUgPV18p6zmIMmLkK2XGWL8+3o=";

  subPackages = [ "cmd/waybar-weather" ];

  ldflags = [
    "-s"
    "-w"
  ];

  postPatch = ''
    substituteInPlace go.mod --replace "go 1.25.6" "go 1.25.5"
  '';

  meta = with lib; {
    description = "Waybar weather module with Open-Meteo and automatic geolocation";
    homepage = "https://github.com/wneessen/waybar-weather";
    license = licenses.mit;
    mainProgram = "waybar-weather";
    platforms = platforms.linux;
  };
}
