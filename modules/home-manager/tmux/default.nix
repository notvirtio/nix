{ config, lib, pkgs, ... }:

let colors = config.colorScheme.colors;
in {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    prefix = "C-Space";
    clock24 = true;

    plugins = with pkgs.tmuxPlugins; [ vim-tmux-navigator continuum ];

    baseIndex = 1;
    extraConfig = ''
      set-option -g status-position top
      set-option -ga terminal-overrides ",alacritty:Tc"
      set -g default-terminal "alacritty"
      set -g @continuum-restore 'on'
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

      # funky colors
      set-window-option -g window-status-current-style "bg=#${colors.base05},fg=#${colors.base00}"
      set-option -g status-style "fg=#${colors.base05},bg=#${colors.base01}"

      # default window title colors
      set-window-option -g window-status-style "fg=#${colors.base04},bg=default"

      # active window title colors
      set-window-option -g window-status-current-style "fg=#${colors.base0A},bg=default"

      # pane border
      set-option -g pane-border-style "fg=#${colors.base01}"
      set-option -g pane-active-border-style "fg=#${colors.base02}"

      # message text
      set-option -g message-style "fg=#${colors.base05},bg=#${colors.base01}"

      # pane number display
      set-option -g display-panes-active-colour "#${colors.base0B}"
      set-option -g display-panes-colour "#${colors.base0A}"

      # clock
      set-window-option -g clock-mode-colour "#${colors.base0B}"

      # copy mode highligh
      set-window-option -g mode-style "fg=#${colors.base04},bg=#${colors.base02}"

      # bell
      set-window-option -g window-status-bell-style "fg=#${colors.base01},bg=#${colors.base08}"
    '';
  };
}
