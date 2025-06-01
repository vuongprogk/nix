{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.tmux;

in {
  options.modules.tmux = { enable = mkEnableOption "tmux"; };
  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      terminal = "tmux-256color";
      historyLimit = 1000;  # Reduced from 100000 for faster startup
      prefix = "C-a";
      mouse = true;
      shell = "${pkgs.zsh}/bin/zsh";
      keyMode = "vi";
      escapeTime = 10;
      baseIndex = 1;
      sensibleOnTop = true;

      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
        {
          plugin = prefix-highlight;
          extraConfig = ''
            set -g @prefix_highlight_output_prefix "#[fg=#e0af68]#[bg=#16161e]#[fg=#16161e]#[bg=#e0af68]"
            set -g @prefix_highlight_output_suffix ""
          '';
        }
      ];

      extraConfig = ''
        # Performance optimizations
        set -g status-interval 5          # Update status every 5 seconds instead of default 15
        set -g display-time 1000          # Reduce display time for messages
        set -g repeat-time 600            # Increase repeat time for repeatable commands
        
        # Terminal and display settings
        set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
        set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours

        # Key bindings
        unbind C-b
        unbind %
        unbind '"'
        unbind r
        unbind -T copy-mode-vi MouseDragEnd1Pane

        bind-key C-a send-prefix
        bind | split-window -h 
        bind - split-window -v
        bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

        # Resize Pane (with repeat)
        bind -r j resize-pane -D 5
        bind -r k resize-pane -U 5
        bind -r l resize-pane -R 5
        bind -r h resize-pane -L 5
        bind -r m resize-pane -Z

        # Copy mode bindings
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-selection

        # TokyoNight colorscheme - optimized for performance
        set -g mode-style "fg=#7aa2f7,bg=#3b4261"
        set -g message-style "fg=#7aa2f7,bg=#3b4261"
        set -g message-command-style "fg=#7aa2f7,bg=#3b4261"
        set -g pane-border-style "fg=#3b4261"
        set -g pane-active-border-style "fg=#7aa2f7"
        
        # Status bar - simplified for better performance
        set -g status "on"
        set -g status-justify "left"
        set -g status-style "fg=#7aa2f7,bg=#16161e"
        set -g status-left-length "50"
        set -g status-right-length "80"
        
        # Simplified status format (removed complex shell commands)
        set -g status-left "#[fg=#15161e,bg=#7aa2f7,bold] #S #[fg=#7aa2f7,bg=#16161e]"
        set -g status-right "#[fg=#7aa2f7,bg=#16161e] #{prefix_highlight} #[fg=#7aa2f7,bg=#3b4261] %Y-%m-%d %H:%M #[fg=#15161e,bg=#7aa2f7,bold] #h "
        
        # Window status - simplified
        setw -g window-status-activity-style "underscore,fg=#a9b1d6,bg=#16161e"
        setw -g window-status-separator ""
        setw -g window-status-style "NONE,fg=#a9b1d6,bg=#16161e"
        setw -g window-status-format " #I #W #F "
        setw -g window-status-current-format "#[fg=#7aa2f7,bg=#3b4261,bold] #I #W #F "
      '';
    };
  };
}
