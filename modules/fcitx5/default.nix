{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.fcitx5;

in {
    options.modules.fcitx5 = { enable = mkEnableOption "fcitx5"; };
    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        fcitx5 fcitx5-unikey
      ];
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.addons = with pkgs; [ fcitx5-unikey ];
      };
      services.fcitx5.enable = true;
    };
}
