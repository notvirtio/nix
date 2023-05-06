{ config, lib, pkgs, ... }:

let
  colors = config.colorScheme.colors;
in {
  programs.qutebrowser = {
    enable = true;
    settings.colors = {
      webpage.preferred_color_scheme = "${config.colorScheme.kind}";
    };
    extraConfig = ''
import dracula

config.load_autoconfig()

dracula.blood(c, {
    'spacing': {
        'vertical': 6,
        'horizontal': 8
    }
})
    '';
  };
  home.file.".config/qutebrowser/dracula.py".source = ../dracula.py;
}
