{ pkgs, lib, config, ... }:
with lib;
let 
  cfg = config.modules.zsh;
in {
    options.modules.zsh = { enable = mkEnableOption "zsh"; };

    config = mkIf cfg.enable {
    	home.packages = with pkgs;[
        zsh
        nodejs
        nodePackages.npm
        nodePackages.nodemon
        nodePackages.typescript
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
            initExtra = ''
              # Initialize oh-my-posh with custom config
                eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config ~/craver.omp.json)"

                # Initialize zoxide (directory navigation)
                eval "$(zoxide init zsh)"

                # Add paths to the PATH environment variable in one line
                export PATH="$PATH:/home/ace/.dotnet/tools:$HOME/.npm-global:/home/ace/Downloads/flutter/bin"

                # Set JAVA_HOME dynamically based on javac location
                export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))

                # Enable zsh-completions (ensure the plugin is available)
                [[ -f $ZSH/completions/_* ]] && source $ZSH/completions/_*

                # Enable fzf fuzzy completion if it's available
                [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
                ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan';  # Change suggestion color
                ZSH_AUTOSUGGEST_STRATEGY=(history completion); # Look at both history and completion
            '';

            # basically aliases for directories: 
            # `cd ~dots` will cd into ~/.config/nixos
            dirHashes = {
                dots = "$HOME/.config/nixos";
                media = "/run/media/$USER";
            };

            # Tweak settings for history
            history = {
                save = 1000;
                size = 1000;
                path = "$HOME/.cache/zsh_history";
            };

            # Set some aliases
            shellAliases = {
                c = "clear";
                mkdir = "mkdir -vp";
                rm = "rm -rifv";
                mv = "mv -iv";
                cp = "cp -riv";
                cat = "bat --paging=never --style=plain";
                ls = "exa -a --icons";
                tree = "exa --tree --icons";
                nd = "nix develop -c $SHELL";
                rebuild = "doas -u ace nixos-rebuild switch --flake .#$(hostname) --fast; notify-send 'Rebuild complete\!'";
                ll = "ls -l";
                cd = "z";
            };

            zplug = {
              enable = true;
              plugins = [
                { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
                { name = "zsh-users/zsh-completions"; }  # Add this for extra completions
              ];
            };
    };
};
}
