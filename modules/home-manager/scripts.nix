{ config, lib, pkgs, ... }:

let
  sc = pkgs.writeShellScriptBin "sc" ''
    name=$(date +%s)
    grim -g "$(slurp)" - | tee ~/pics/sc/$name.png | wl-copy -t image/png
  '';
in {
  home.packages = with pkgs; [
    sc
  ];
}
