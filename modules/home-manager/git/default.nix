{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userEmail = "tobich228@gmail.com"; # It's in the GPG key anyway.
    userName = "notvirtio";
    signing = {
      signByDefault = true;
      key = "E2A038A73BC2239D";
    };
  };

  programs.lazygit.enable = true;
}
