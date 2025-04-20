{  lib, config, pkgs, ... }:
with lib;
let
    cfg = config.modules.nvim;
    # Source my theme
in {
    options.modules.nvim = { enable = mkEnableOption "nvim"; };
    config = mkIf cfg.enable {

        home.file.".config/nvim".source = ./dot;
        
        programs.zsh = {
            initExtra = ''
                export EDITOR="nvim"
            '';

            shellAliases = {
                v = "nvim -i NONE";
                nvim = "nvim -i NONE";
            };
        };

        programs.neovim = {
            enable = true;
        };
    };
}
