{  lib, config, pkgs, ... }:
with lib;
let
    cfg = config.modules.nvim;
in {
    options.modules.nvim = { enable = mkEnableOption "nvim"; };
    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            gnumake lazygit
        ];

        home.sessionVariables = {
            EDITOR = "nvim";
        };

        programs.zsh.shellAliases = mkIf config.modules.zsh.enable {
            v = "nvim";
            nvim = "nvim";
        };

        programs.neovim = {
            enable = true;
            defaultEditor = true;
            viAlias = true;
            vimAlias = true;
        };
    };
}
