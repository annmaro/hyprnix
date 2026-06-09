{
  pkgs,
  inputs,
  self,
  ...
}:

let
  sddm-theme = inputs.silentSDDM.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
    theme = "silvia"; # select the config of your choice
    # Pass the local image so it gets copied into the theme's background folder
    extraBackgrounds = [ (self + "/modules/wallpapers/city-horizon.jpg") ];

    # Tell SilentSDDM to use this image
    theme-overrides = {
      "LoginScreen" = {
        background = "city-horizon.jpg";
      };
      "LockScreen" = {
        background = "city-horizon.jpg";
      };
    };
  };
in
{
  imports = [
    ./icon.nix
  ];
  # include the test package which can be run using test-sddm-silent
  environment.systemPackages = [
    sddm-theme
    sddm-theme.test
  ];
  qt.enable = true;
  services = {
    accounts-daemon.enable = true;
    displayManager = {
      generic.preStart = ''
        echo "Sleeping to wait for session registration..."
        sleep 1
      '';
      defaultSession = "niri";
      sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm; # use qt6 version of sddm
        theme = sddm-theme.pname;
        # the following changes will require sddm to be restarted to take
        # effect correctly. It is recomend to reboot after this
        extraPackages = sddm-theme.propagatedBuildInputs;
        settings = {
          # required for styling the virtual keyboard
          General = {
            GreeterEnvironment = "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard";
            InputMethod = "qtvirtualkeyboard";
          };
        };
      };
    };
  };
}
