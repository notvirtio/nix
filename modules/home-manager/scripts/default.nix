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
  xsc = pkgs.writeShellScriptBin "xsc" ''
    if [[ "$1" == "win" ]]; then
      maim -Bi "$(xdotool selectwindow)" | tee ~/pics/sc/$(date +%s).png | xclip -sel clip -t image/png
    else
      maim -Bs | tee ~/pics/sc/$(date +%s).png | xclip -sel clip -t image/png
    fi
  '';
  clip = pkgs.writeShellScriptBin "clip" ''
    wf-recorder -g "0,0 1920x1080" -c h264_nvenc -f $HOME/clips/`(date +%s)`.mp4 -a
  '';
  config-reload = pkgs.writeShellScriptBin "config-reload" ''
    pkill -x hyprpaper
    hyprpaper &
    tmux source ~/.config/tmux/tmux.conf
  '';
  hypr-toggle = pkgs.writeShellScriptBin "hypr-toggle" ''
    #!/usr/bin/env sh
    HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==2{print $2}')
    if [ "$HYPRGAMEMODE" = 1 ] ; then
        hyprctl --batch "\
            keyword animations:enabled 0;\
            keyword decoration:drop_shadow 0;\
            keyword decoration:blur 0;\
            keyword general:gaps_in 0;\
            keyword general:gaps_out 0;\
            keyword general:border_size 1;\
            keyword decoration:rounding 0"
        exit
    fi
    hyprctl reload
  '';
in {
  home.packages = with pkgs; [
    xsc
    sc
    scwin
    clip
    config-reload
    hypr-toggle
    # dependencies
    maim
    jq
    xdotool
  ];
}
