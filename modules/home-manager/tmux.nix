{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    prefix = "C-Space";
    clock24 = true;

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      {
          plugin = dracula;
          extraConfig = ''
            set -g @dracula-show-battery false
            set -g @dracula-plugins "time"
          '';
      }
    ];

    baseIndex = 1;
    extraConfig = ''
set-option -g status-position top
unbind r

unbind v
unbind h
unbind %
unbind '"'
set -g focus-events on
set -g status-style bg=default
set -g status-left-length 90
set -g status-right-length 90
set -g status-justify centre

bind v split-window -h -c "#{pane_current_path}"
bind h split-window -v -c "#{pane_current_path}"

bind n command-prompt "rename window '%%'"
bind w new-window -c "#{pane_current_path}"

bind -n M-j previous-window
bind -n M-k next-window

set -sg escape-time 20

is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'"
bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

bind-key -n 'C-,' 'send-keys C-,'
bind-key -n 'C-.' 'send-keys C-.'

bind-key -T copy-mode-vi 'C-h' select-pane -L
bind-key -T copy-mode-vi 'C-j' select-pane -D
bind-key -T copy-mode-vi 'C-k' select-pane -U
bind-key -T copy-mode-vi 'C-l' select-pane -R
    '';
  };
}
