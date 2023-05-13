{ config, lib, pkgs, ... }:

let
  sc = pkgs.writeShellScriptBin "sc" ''
    name=$(date +%s)
    grim -g "$(slurp)" - | tee ~/pics/sc/$name.png | wl-copy -t image/png
    find ~/pics/sc -size 0 -delete
  '';
  scwin = pkgs.writeShellScriptBin "scwin" ''
    name=$(date +%s)
    win=$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])'$append'"')
    grim -g "$win" - | tee ~/pics/sc/$name.png | wl-copy -t image/png
    find ~/pics/sc -size 0 -delete
  '';
  clip = pkgs.writeShellScriptBin "clip" ''
    wf-recorder -g "0,0 1920x1080" -c h264_nvenc -f $HOME/clips/`(date +%s)`.mp4 -a
  '';
  ncmpc-wrap = pkgs.writeShellScriptBin "ncmpc-wrap" ''
    ncmpc -h 127.0.0.1 --no-colors
  '';
  config-reload = pkgs.writeShellScriptBin "config-reload" ''
    pkill -x hyprpaper && hyprpaper &
    tmux source ~/.config/tmux/tmux.conf
  '';
in {
  home.packages = with pkgs; [
    ncmpc-wrap
    sc
    scwin
    clip
    config-reload
    # dependencies
    jq
    pavucontrol
  ];
}
