{ config, lib, pkgs, ... }:

{
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ~/pics/bgs/current.png

    wallpaper = HDMI-A-1,~/pics/bgs/current.png
    wallpaper = HDMI-A-2,~/pics/bgs/current.png
  '';

  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    nvidiaPatches = true;
    extraConfig = ''
exec-once = hyprpaper

env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = GBM_BACKEND,nvidia-drm
env = WLR_NO_HARDWARE_CURSORS,1

bind=SUPER,return,exec,foot -e tmux
bind=SUPERSHIFT,return,exec,foot -e tmux attach
bind=SUPER,0,exec,foot -e cava
bind=SUPER,space,exec,rofi -show drun
bind=SUPER,w,exec,firefox
bind=SUPER,p,exec,sc
bind=SUPERSHIFT,p,exec,scwin
bind=SUPER,i,exec,foot -T FootFloat -e clip
bind=SUPER,o,exec,foot -e ncmpc-wrap
bind=SUPER,f,exec,nemo
windowrule=float,title:^(FootFloat)(.*)$
bind=SUPER,q,killactive

bind=SUPER,s,togglefloating
bind=SUPER,m,fullscreen,1
bind=SUPERSHIFT,m,fullscreen,0

bind=SUPER,h,movefocus,l
bind=SUPER,j,movefocus,d
bind=SUPER,k,movefocus,u
bind=SUPER,l,movefocus,r

bind=SUPER,1,workspace,1
bind=SUPER,2,workspace,2
bind=SUPER,3,workspace,3
bind=SUPER,4,workspace,4
bind=SUPER,5,workspace,5
bind=SUPER,6,workspace,6
bind=SUPER,7,workspace,7
bind=SUPER,8,workspace,8
bind=SUPER,9,workspace,9

bind=SUPERSHIFT,1,movetoworkspacesilent,1
bind=SUPERSHIFT,2,movetoworkspacesilent,2
bind=SUPERSHIFT,3,movetoworkspacesilent,3
bind=SUPERSHIFT,4,movetoworkspacesilent,4
bind=SUPERSHIFT,5,movetoworkspacesilent,5
bind=SUPERSHIFT,6,movetoworkspacesilent,6
bind=SUPERSHIFT,7,movetoworkspacesilent,7
bind=SUPERSHIFT,8,movetoworkspacesilent,8
bind=SUPERSHIFT,9,movetoworkspacesilent,9

bindm=SUPER,mouse:272,movewindow
bindm=SUPER,mouse:273,resizewindow

general {
  gaps_out = 40
  gaps_in = 10
  no_cursor_warps = true
}

decoration {
  rounding = 8
  drop_shadow = false
}

input {
  kb_options = caps:escape,grp:alt_shift_toggle
  kb_layout = us,ru
  accel_profile = flat
}

misc {
  animate_manual_resizes = true
  animate_mouse_windowdragging = true
}

monitor=HDMI-A-1,highres,0x0,1
monitor=HDMI-A-2,highres,1920x0,1

workspace=HDMI-A-2, 9
wsbind=9,HDMI-A-2
    '';
  };
}
