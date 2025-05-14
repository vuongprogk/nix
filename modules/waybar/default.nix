
{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.waybar;

in {
    options.modules.waybar = { enable = mkEnableOption "waybar"; };
    config = mkIf cfg.enable {
        programs.waybar = {
            enable = true;
        };
        home.file.".config/waybar".source = ./waybar;
}
