{ pkgs, lib, config, ... }:

with lib;
let cfg = 
    config.modules.packages;
in {
    options.modules.packages = { enable = mkEnableOption "packages"; };
    config = mkIf cfg.enable {
    	home.packages = with pkgs; [
          ripgrep ffmpeg eza htop fzf gnupg bat unzip pavucontrol blueman
          imagemagick libnotify git python3 lua zig firefox postman
          wf-recorder go docker minikube zoxide perl wpsoffice
          ntfs3g docker-compose vscode fd yazi tmux kubectl
          dotnet-sdk dotnet-ef dotnet-aspnetcore confluent-cli
          vlc kdePackages.xwaylandvideobridge xwayland
          google-chrome rustc cargo cmake ninja pkg-config gtk3 clang openjdk17 android-studio
    ];
  };
}
