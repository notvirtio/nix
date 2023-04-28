{ config, lib, pkgs, ... }:

{
  programs.gnupg = {
    agent = {
      enable = true;
      pinentryFlavor = "qt";
    };
  };
}
