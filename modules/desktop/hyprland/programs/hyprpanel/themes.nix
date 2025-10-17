{ lib, inputs, ...}: 

let
  inherit (lib.trivial) importJSON;
in 

{
  
  programs.hyprpanel = {
      settings = {
      theme = (importJSON ./themes/catppuccin_mocha.json) // {
        # name = "catppuccin_mocha";
        
      /*   font = {
         name = "JetBrainsMonoNF-Regular";
         size = "16px";

        # I Fucking Hate Rounded Courners Fuck Off
        # These defaults are actually fucking ridiculous why is there no option to disable them all holy shit
        bar = {
          border_radius = "0.0em";
          outer_spacing = "0.0em";
          floating = false;
          buttons = {
            innerRadiusMultiplier = "0.0";
            radius = "0.0em";
            workspaces.pill.radius = "1.9rem";
          };
          menus = {
            border.radius = "0.0em";
            buttons.radius = "0.0em";
            card_radius = "0.0em";
            menu.dashboard.profile.radius = "0.0em";
            menu.notifications.scrollbar.radius = "0.0em";
            menu.power.radius = "0.0em";
            popover.radius = "0.0em";
            progressbar.radius = "0.0rem";
            scroller.radius = "0.0em";
            slider.progress_radius = "0.0rem";
            slider.slider_radius = "0.0rem";
            switch.radius = "0.0em";
            switch.slider_radius = "0.0em";
            tooltip.radius = "0.0em";
          };
        };
        notification.border_radius = "0.0em";
        osd.radius = "0.0em"; */
      };
    };
  };
}

