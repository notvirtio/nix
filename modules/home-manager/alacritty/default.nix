{ config, lib, pkgs, ... }:

let colors = config.colorScheme.colors;
in {
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    window.opacity = 0.8;

    font = {
      normal.family = "Mononoki Nerd Font";
      size = 18;
    };

    cursor.shape = "Underline";

    colors = {
      primary = {
        background = "#${colors.base00}";
        foreground = "#${colors.base05}";
      };
      cursor = {
        text = "#${colors.base00}";
        cursor = "#${colors.base05}";
      };
      normal = {
        black = "#${colors.base00}";
        red = "#${colors.base08}";
        green = "#${colors.base0B}";
        yellow = "#${colors.base0A}";
        blue = "#${colors.base0D}";
        magenta = "#${colors.base0E}";
        cyan = "#${colors.base0C}";
        white = "#${colors.base05}";
      };
      bright = {
        black = "#${colors.base03}";
        red = "#${colors.base09}";
        green = "#${colors.base01}";
        yellow = "#${colors.base02}";
        blue = "#${colors.base04}";
        magenta = "#${colors.base06}";
        cyan = "#${colors.base0F}";
        white = "#${colors.base07}";
      };
    };
  };
}
