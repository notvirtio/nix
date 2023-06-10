{ config, lib, pkgs, ... }:

let colors = config.colorScheme.colors;
in {
  services.mako.enable = true;
  services.mako = {
    anchor = "top-center";
    backgroundColor = "#${colors.base00}";
    borderColor = "#${colors.base0D}";
    textColor = "#${colors.base05}";

    layer = "overlay";
    defaultTimeout = 5000;
    output = "HDMI-A-1";

    extraConfig = ''
      [urgency=low]
      background-color=#${colors.base00}
      text-color=#${colors.base0A}
      border-color=#${colors.base0D}

      [urgency=high]
      background-color=#${colors.base00}
      text-color=#${colors.base08}
      border-color=#${colors.base0D}
    '';
  };
}
