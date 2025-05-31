{  lib, config, pkgs, ... }:
with lib;
let
    cfg = config.modules.nvim;
    # Source my theme
in {
    options.modules.nvim = { enable = mkEnableOption "nvim"; };
    config = mkIf cfg.enable {
      home.packages = with pkgs;[
        gnumake lazygit
      ];

        programs.zsh = {
            initContent= ''
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
