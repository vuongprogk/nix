{ inputs, pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.hyprland;

in {
  options.modules.hyprland= { enable = mkEnableOption "hyprland"; };
  config = mkIf cfg.enable {
	home.packages = with pkgs; [
	    wofi wlsunset wl-clipboard hyprland hyprcursor hyprlock hypridle waybar hyprpaper
	];

        home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
        home.file.".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
        home.file.".config/hypr/assets/wall.png".source = ./assets/wall.png;
    };
}
