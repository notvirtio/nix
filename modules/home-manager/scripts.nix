{ config, lib, pkgs, ... }:

let
  sc = pkgs.writeShellScriptBin "sc" ''
    name=$(date +%s)
    grim -g "$(slurp)" - | tee ~/pics/sc/$name.png | wl-copy -t image/png
  '';
  ncmpc-wrap = pkgs.writeShellScriptBin "ncmpc-wrap" ''
    ncmpc -h 127.0.0.1 --no-colors
  '';
in {
  home.packages = with pkgs; [
   ncmpc-wrap sc
  ];
}
