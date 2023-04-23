{ config, lib, pkgs, ... }:

{
  home.file.".config/rofi/nord.rasi".source = ./nord.rasi;

  programs.rofi.enable = true;
  programs.rofi.package = pkgs.rofi-wayland;

  programs.rofi.theme = "~/.config/rofi/nord.rasi";
}
