{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.rider;

in {
    options.modules.rider = { enable = mkEnableOption "rider"; };
    config = mkIf cfg.enable {
      programs.jetbrains.rider = {
        enable = true;
        package = pkgs.jetbrains.rider.override {
          enableFhsSupport = true;
        };
      };
    };
}
