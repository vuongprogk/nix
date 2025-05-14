 { inputs, lib, config, pkgs, ... }:
with lib;
let
    cfg = config.modules.eww;
in {
    options.modules.eww = { enable = mkEnableOption "eww"; };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            eww
            pamixer
            brightnessctl
        ];

        # configuration
        home.file.".config/eww/eww.scss".source = ./eww.scss;
        home.file.".config/eww/eww.yuck".source = ./eww.yuck;
        home.file."config/eww/Main".source = ./eww/Main;
        home.file."config/eww/Misc".source = ./eww/Misc;
        home.file."config/eww/Player".source = ./eww/Player;
        home.file."config/eww/System-Menu".source = ./eww/System-Menu;
    };
}
