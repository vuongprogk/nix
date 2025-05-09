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
      home.sessionVariables = {
        GDK_SCALE = "1";
        GDK_DPI_SCALE = "1";
        _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1.0";
        LIBGL_ALWAYS_SOFTWARE = "1";
        _JAVA_AWT_WM_NONREPARENTING = "1";
      };
    };
}
