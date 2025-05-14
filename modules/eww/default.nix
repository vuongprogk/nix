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
        home.file."config/eww".source = ./eww;
    };
}
