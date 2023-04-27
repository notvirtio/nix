{ config, lib, pkgs, ... }:

{
  xdg.desktopEntries = {
    armcord = {
      name = "ArmCord";
      exec = "armcord %U --no-sandbox";
      terminal = false;
      categories = [ "Network" ];
    };
  };
}
