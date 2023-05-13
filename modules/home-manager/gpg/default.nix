{ config, lib, pkgs, ... }:

{
  programs.gnupg = {
    agent = {
      enable = true;
      pinetryFlavor = "qt";
    };
  };
}
