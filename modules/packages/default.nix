{ pkgs, lib, config, ... }:

with lib;
let cfg = 
    config.modules.packages;
in {
    options.modules.packages = { enable = mkEnableOption "packages"; };
    config = mkIf cfg.enable {
    	home.packages = with pkgs; [
          ripgrep ffmpeg tealdeer eza htop fzf pass gnupg bat unzip lowdown zk
          grim slurp slop imagemagick age libnotify git python3 lua zig mpv firefox pqiv
          wf-recorder anki-bin go docker minikube zoxide perl gradle
          ntfs3g docker-compose vscode fd yazi tmux kubectl networkmanagerapplet 
          dotnetCorePackages.sdk_8_0_3xx
          vlc discord lazygit xdg-desktop-portal-hyprland kdePackages.xwaylandvideobridge fzf 
          jetbrains.rider swaynotificationcenter google-chrome
          cmake ninja pkg-config gtk3 clang rustc cargo flutter jdk android-studio
      ];
  };
}
