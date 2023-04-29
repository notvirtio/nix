{ config, lib, pkgs, ... }:

{
  home.file.".config/rofi/nord.rasi".source = ../nord.rasi;
  home.file.".config/rofi/dracula.rasi".source = ../dracula.rasi;

  programs.rofi.enable = true;
  programs.rofi.package = pkgs.rofi-wayland;

  programs.rofi.theme = "~/.config/rofi/dracula.rasi";
}
