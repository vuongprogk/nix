{  lib, config, pkgs, ... }:
with lib;
let
    cfg = config.modules.rider;
    # Source my theme
in {
    options.modules.rider = { enable = mkEnableOption "rider"; };
    config = mkIf cfg.enable {
      home.packages = with pkgs;[
        jetbrains.rider
      ];
    };
}
