{ pkgs, terminal, ... }:

pkgs.writeShellApplication {
  name = "file-manager";

  # Nix ensures these GUI tools and terminal file managers are available in the script PATH
  runtimeInputs = with pkgs; [
    coreutils
    thunar
    dolphin
    nautilus
    pcmanfm
    nemo
    yazi
    lf
    nnn
    ranger
    mc
  ];

  text = ''
    case "$1" in
      thunar)   thunar ;;
      dolphin)  dolphin ;;
      nautilus) nautilus ;;
      pcmanfm)  pcmanfm ;;
      nemo)     nemo ;;
      yazi)     ${terminal} --class "tuiFileManager" -e yazi ;;
      lf)       ${terminal} --class "tuiFileManager" -e lf ;;
      nnn)      ${terminal} --class "tuiFileManager" -e nnn ;;
      ranger)   ${terminal} --class "tuiFileManager" -e ranger ;;
      mc)       ${terminal} --class "tuiFileManager" -e mc ;;
      *)        echo "Unknown file manager layout profile requested: $1"; exit 1 ;;
    esac
  '';
}