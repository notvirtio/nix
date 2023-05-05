{ config, lib, pkgs, ... }:

{
  xdg.desktopEntries = {
    armcord = {
      name = "ArmCord";
      exec = "armcord %U --no-sandbox";
      terminal = false;
      categories = [ "Network" ];
    };
    craftos = {
      name = "CraftOS-PC";
      exec = "env SDL_VIDEODRIVER=wayland craftos";
      terminal = false;
      categories = [ "Utility" "Development" ];
    };
  };
}
