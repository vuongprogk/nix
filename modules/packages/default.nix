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
          wf-recorder anki-bin go docker minikube zoxide perl
          ntfs3g docker-compose vscode fd yazi tmux kubectl networkmanagerapplet 
          dotnet-sdk dotnet-ef dotnet-aspnetcore
          vlc discord xdg-desktop-portal-hyprland kdePackages.xwaylandvideobridge
          swaynotificationcenter google-chrome libfprint usbutils
          rustc cargo android-studio cmake ninja pkg-config gtk3 clang openjdk17
      ];
  };
}
