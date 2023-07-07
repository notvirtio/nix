{ config, lib, pkgs, nix-colors, ... }:

let
  inherit (nix-colors.lib-contrib { inherit pkgs; }) nixWallpaperFromScheme;
  wallpaper = nixWallpaperFromScheme {
    scheme = config.colorScheme;
    width = 1920;
    height = 1080;
    logoScale = 6.0;
  };
  colors = config.colorScheme.colors;
in {
  home.packages = with pkgs; [ xclip feh ];
  services.picom.enable = true;
  xsession.windowManager.bspwm = {
    enable = true;
    settings = {
      split_ratio = 0.5;
      pointer_modifier = "mod4";
      normal_border_color = "#${colors.base02}";
      active_border_color = "#${colors.base02}";
      focused_border_color = "#${colors.base0C}";
      focus_follows_pointer = true;
      window_gap = 20;
    };
    monitors = {
      HDMI-0 = [ "1" "2" "3" "4" "5" ];
      HDMI-1 = [ "6" "7" "8" "9" "10" ];
    };
    startupPrograms = [
      "armcord"
      "picom"
      "setxkbmap -layout us,us,ru -variant dvorak,, -option grp:alt_shift_toggle,caps:escape"
      "xinput --set-prop 'Logitech G102 LIGHTSYNC Gaming Mouse' 'Device Accel Profile' -1"
      "feh --bg-scale ${wallpaper}"
      "xsetroot -cursor_name left_ptr"
    ];
    rules = { "TermFloat" = { state = "floating"; }; };
  };
  services.sxhkd = {
    enable = true;
    keybindings = {
      "super + Escape" = "pkill -USR1 -x sxhkd";
      "super + Return" = "alacritty -e tmux";
      "super + shift + Return" = "alacritty -e tmux attach";
      "super + c" = "gnome-calculator";
      "super + space" = "rofi -show drun";
      "super + w" = "firefox";
      "super + {_,shift +} p" = "xsc {win,sel}";
      "super + o" = "alacritty --class TermFloat -e ncmpcpp";
      "super + f" = "pcmanfm";
      "super + {_,shift +} x" = "bspc node -{c,k}";
      "super + {t,s,m}" = "bspc node -t {tiled,floating,fullscreen}";
      "super + {_,shift +} {1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";
      "super + {h,j,k,l}" = "bspc node -f {west,south,north,east} --follow";
      "super + shift + {h,j,k,l}" =
        "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
      "super + minus" = "config-reload";
    };
  };
}
