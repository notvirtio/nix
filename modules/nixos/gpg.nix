{ config, lib, pkgs, ... }:

{
  services.pcscd.enable = true;
  programs.gnupg = {
    agent = {
      enable = true;
      pinentryFlavor = "qt";
    };
  };

  environment.systemPackages = with pkgs; [
    pinentry-qt
  ];
}
