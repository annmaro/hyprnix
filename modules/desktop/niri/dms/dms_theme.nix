# dms_theme.nix
{ ... }:

{
  id = "amoledBlack";
  name = "Amoled Black";
  version = "1.0.0";
  author = "acup";
  description = "absolutle black";
  dark = { };
  light = { };
  variants = {
    type = "multi";
    defaults = {
      dark = {
        accent = "yellow";
        flavor = "black";
      };
      light = {
        accent = "white";
        flavor = "black-light";
      };
    };
    flavors = [
      {
        id = "black";
        name = "black";
        dark = {
          primaryText = "#000000";
          primaryContainer = "#CC5200";
          secondary = "#999999";
          surface = "#000000";
          surfaceText = "#E6F0FF";
          surfaceVariant = "#000000";
          surfaceVariantText = "#FFFFFF";
          surfaceTint = "#FF6600";
          background = "#000000";
          backgroundText = "#FFFFFF";
          outline = "#555555";
          surfaceContainer = "#000000";
          surfaceContainerHigh = "#000000";
          error = "#DD0000";
          warning = "#FFCC00";
          info = "#999999";
        };
        light = { };
      }
      {
        id = "black-light";
        name = "black";
        dark = { };
        light = {
          primaryText = "#000000";
          primaryContainer = "#CC5200";
          secondary = "#999999";
          surface = "#000000";
          surfaceText = "#E6F0FF";
          surfaceVariant = "#000000";
          surfaceVariantText = "#FFFFFF";
          surfaceTint = "#FF6600";
          background = "#000000";
          backgroundText = "#FFFFFF";
          outline = "#555555";
          surfaceContainer = "#000000";
          surfaceContainerHigh = "#000000";
          error = "#DD0000";
          warning = "#FFCC00";
          info = "#999999";
        };
      }
    ];
    accents = [
      {
        id = "white";
        name = "white";
        black.primary = "#FFFFFF";
        black-light.primary = "#FFFFFF";
      }
      {
        id = "red";
        name = "red";
        black.primary = "#FF0000";
        black-light.primary = "#FF0000";
      }
      {
        id = "maroon";
        name = "maroon";
        black.primary = "#800000";
        black-light.primary = "#800000";
      }
      {
        id = "green";
        name = "green";
        black.primary = "#00FF00";
        black-light.primary = "#00FF00";
      }
      {
        id = "dark-green";
        name = "dark green";
        black.primary = "#008000";
        black-light.primary = "#008000";
      }
      {
        id = "greenyellow";
        name = "greenyellow";
        black.primary = "#ADFF2F";
        black-light.primary = "#ADFF2F";
      }
      {
        id = "coral";
        name = "coral";
        black.primary = "#03fc7b";
        black-light.primary = "#03fc7b";
      }
      {
        id = "blue";
        name = "blue";
        black.primary = "#0000FF";
        black-light.primary = "#0000FF";
      }
      {
        id = "turquoise";
        name = "turquoise";
        black.primary = "#03fcc6";
        black-light.primary = "#03fcc6";
      }
      {
        id = "purple";
        name = "purple";
        black.primary = "#CC00FF";
        black-light.primary = "#CC00FF";
      }
      {
        id = "pink";
        name = "pink";
        black.primary = "#fc03eb";
        black-light.primary = "#fc03eb";
      }
      {
        id = "yellow";
        name = "yellow";
        black.primary = "#fabd2f";
        black-light.primary = "#fabd2f";
      }
      {
        id = "orange";
        name = "orange";
        black.primary = "#E78A4E";
        black-light.primary = "#E78A4E";
      }
      {
        id = "light-orange";
        name = "light orange";
        black.primary = "#ff7b00";
        black-light.primary = "#ff7b00";
      }
    ];
  };
  sourceDir = "amoled-black-theme";
}
