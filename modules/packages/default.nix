{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.packages;
in {
  options.modules.packages = { enable = mkEnableOption "packages"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # System utilities
      ripgrep fd bat eza htop fzf yazi zoxide
      ffmpeg imagemagick libnotify unzip ntfs3g
      
      # Development tools
      git python3 lua zig go rustc cargo
      cmake ninja pkg-config gtk3 clang
      openjdk17 dotnet-sdk dotnet-ef dotnet-aspnetcore
      
      # Databases and containers
      docker docker-compose minikube kubectl
      confluent-cli
      
      # Applications
      firefox google-chrome postman
      vlc wpsoffice android-studio
      vscode wf-recorder
      
      # Audio/Video
      pavucontrol blueman
      kdePackages.xwaylandvideobridge xwayland
      
      # Development dependencies (Node.js moved to zsh module)
      perl tmux gnupg
    ];
  };
}
