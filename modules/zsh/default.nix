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

        programs.zsh = {
            enable = true;

            # directory to put config files in
            dotDir = ".config/zsh";

            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;

            # .zshrc
            initExtra = ''
                eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config ~/craver.omp.json)"
                eval "$(zoxide init zsh)"
                export PATH="$PATH:/home/ace/.dotnet/tools"
                export PATH="$PATH:$HOME/.npm-global"
                export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))
                export PATH="/home/ace/Downloads/flutter/bin:$PATH"
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
              ];
            };
    };
};
}
