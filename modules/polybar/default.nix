
 { inputs, lib, config, pkgs, ... }:
with lib;
let
    cfg = config.modules.polybar;
in {
    options.modules.polybar = { enable = mkEnableOption "polybar"; };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            polybar
        ];
        home.file.".config/polybar".source = ./polybar;
    };
}
