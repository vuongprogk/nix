{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.xdg;

in {
    options.modules.xdg = { enable = mkEnableOption "xdg"; };
    config = mkIf cfg.enable {
        xdg.userDirs = {
            enable = true;
            documents = "$HOME/Documents/";
            download = "$HOME/Download/";
            videos = "$HOME/Videos/";
            music = "$HOME/Music/";
            pictures = "$HOME/Pictures/";
            desktop = "$HOME/Desktop/";
            publicShare = "$HOME/PublicShare/";
            templates = "$HOME/Templates/";
        };
    };
}
