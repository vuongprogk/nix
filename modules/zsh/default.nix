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
            # .zshrc
            initContent = ''
              # Initialize oh-my-posh with custom config
              eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config ~/craver.omp.json)"

              # Initialize zoxide (directory navigation)
              eval "$(zoxide init zsh)"

              # Add paths to the PATH environment variable
              export PATH="$PATH:$HOME/.dotnet/tools:$HOME/.npm-global:$HOME/Documents/flutter/bin"

              # Set JAVA_HOME dynamically based on javac location
              if command -v javac >/dev/null 2>&1; then
                export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))
              fi

              # Enable fzf fuzzy completion if it's available
              [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
              
              ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'
              ZSH_AUTOSUGGEST_STRATEGY=(history completion)
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

            # Tweak settings for history
            history = {
                save = 10000;
                size = 10000;
                path = "$HOME/.cache/zsh_history";
                ignoreDups = true;
                share = true;
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

            zplug = {
              enable = true;
              plugins = [
                { name = "zsh-users/zsh-autosuggestions"; }
                { name = "zsh-users/zsh-syntax-highlighting"; }
                { name = "zsh-users/zsh-completions"; }
              ];
            };
    };
};
}
