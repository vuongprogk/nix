{ inputs, pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.hyprland;

in {
  options.modules.hyprland= { enable = mkEnableOption "hyprland"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
        wlsunset wl-clipboard hyprland hyprcursor hyprlock hypridle hyprpaper
    ];
    home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
    home.file.".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
    home.file.".config/hypr/hypridle.conf".source = ./hypridle.conf;
    home.file.".config/hypr/assets/wall.png".source = ./assets/wall.png;
    home.file.".config/fcitx5/conf/classicui.conf".source = ./classicui.conf;
    programs.hyprlock.enable = true;
  };
}
