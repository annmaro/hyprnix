{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.foot = {
        enable = true;
        server.enable = true;
        settings = {
          main = {
            font = pkgs.lib.mkForce "JetBrainsMono Nerd Font:size=14";
            # Assuming catppuccin or stylix will configure colors, but as a fallback:
            include = "${pkgs.foot.themes}/share/foot/themes/catppuccin-mocha";
          };
          scrollback = {
            lines = 10000;
          };
          bell = {
            urgent = "no";
            notify = "no";
          };
          mouse = {
            hide-when-typing = "yes";
          };
          key-bindings = {
            spawn-terminal = "Control+Alt+n";
            clipboard-copy = "Alt+w";
            clipboard-paste = "Control+y";
          };
        };
      };
    })
  ];
}
