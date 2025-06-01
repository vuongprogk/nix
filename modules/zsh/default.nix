{ pkgs, lib, config, ... }:
with lib;
let 
  cfg = config.modules.zsh;
in {
    options.modules.zsh = { enable = mkEnableOption "zsh"; };

    config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Shell and runtime
      zsh oh-my-posh
      
      # Node.js ecosystem
      nodejs nodePackages.npm nodePackages.nodemon
      nodePackages.typescript bun
    ];

        home.file."craver.omp.json".source = ./craver.omp.json;
        
        programs.zsh = {
            enable = true;

            # directory to put config files in
            dotDir = ".config/zsh";

            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;
            # .zshrc - optimized for performance
            initContent = ''
              # Performance: Create cache directory if it doesn't exist
              [[ ! -d ~/.cache ]] && mkdir -p ~/.cache

              # Initialize oh-my-posh with caching
              if [[ ! -f ~/.cache/omp_init ]] || [[ ~/craver.omp.json -nt ~/.cache/omp_init ]]; then
                ${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config ~/craver.omp.json > ~/.cache/omp_init
              fi
              source ~/.cache/omp_init

              # Initialize zoxide with lazy loading
              if command -v zoxide >/dev/null 2>&1; then
                eval "$(zoxide init zsh)"
              fi

              # Optimize PATH modifications
              typeset -U path  # Remove duplicates automatically
              path=(
                $HOME/.dotnet/tools
                $HOME/.npm-global
                $HOME/Documents/flutter/bin
                $path
              )

              # Cache JAVA_HOME detection to avoid repeated filesystem calls
              if [[ -z "$JAVA_HOME" ]] && command -v javac >/dev/null 2>&1; then
                export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))
              fi

              # Lazy load fzf to improve startup time
              fzf_lazy_load() {
                if [[ -f ~/.fzf.zsh ]]; then
                  source ~/.fzf.zsh
                  unfunction fzf_lazy_load
                fi
              }
              
              # Autosuggestion optimization
              ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'
              ZSH_AUTOSUGGEST_STRATEGY=(history)  # Removed completion for speed
              ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20   # Limit buffer size
              ZSH_AUTOSUGGEST_USE_ASYNC=1          # Use async suggestions
            '';

            # basically aliases for directories: 
            # `cd ~dots` will cd into ~/.config/nixos
            dirHashes = {
                dots = "$HOME/.config/nixos";
                dl = "$HOME/Downloads";
                docs = "$HOME/Documents";
                pics = "$HOME/Pictures";
                vids = "$HOME/Videos";
                music = "$HOME/Music";
                media = "/run/media/$USER";
            };

            # Optimized history settings for performance
            history = {
                save = 5000;        # Reduced from 10000
                size = 5000;        # Reduced from 10000
                path = "$HOME/.cache/zsh_history";
                ignoreDups = true;
                share = false;      # Disabled sharing for better performance
                ignoreSpace = true; # Ignore commands starting with space
                expireDuplicatesFirst = true;
            };

            # Set some aliases
            shellAliases = {
                # System
                c = "clear";
                mkdir = "mkdir -vp";
                rm = "rm -rifv";
                mv = "mv -iv";
                cp = "cp -riv";
                
                # Better alternatives
                cat = "bat --paging=never --style=plain";
                ls = "eza -a --icons";
                ll = "eza -la --icons";
                tree = "eza --tree --icons";
                cd = "z";
                
                # Development
                v = "nvim";
                nd = "nix develop -c $SHELL";
                rebuild = "sudo nixos-rebuild switch --flake .#$(hostname) --fast; notify-send 'Rebuild complete!'";
            };

            # Remove zplug to avoid redundant plugin loading
            # plugins are already loaded via enableCompletion, autosuggestion, syntaxHighlighting
            # zplug = {
            #   enable = true;
            #   plugins = [
            #     { name = "zsh-users/zsh-autosuggestions"; }      # Redundant
            #     { name = "zsh-users/zsh-syntax-highlighting"; } # Redundant
            #     { name = "zsh-users/zsh-completions"; }         # Redundant
            #   ];
            # };
    };
};
}
