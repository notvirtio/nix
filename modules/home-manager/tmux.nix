{ config, lib, pkgs, ... }:

{
  home.file.".tmux.conf".source = ./tmux.conf;

  programs.tmux.enable = true;
}
