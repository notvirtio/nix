{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    cool-retro-term
  ];
}
