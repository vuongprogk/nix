{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.dunst;
# Lightweight and customizable notification daemon
in {
    options.modules.dunst = { enable = mkEnableOption "dunst"; };
    config = mkIf cfg.enable {
	home.packages = with pkgs; [
	    dunst
	];
    services.dunst = {
      enable = true;
    };
    home.file."${config.home.homeDirectory}/.config/dunst/dunstrc".source = ./dunstrc;
  };
}
