{ pkgs, lib, config, ... }:

with lib;
let cfg = 
    config.modules.packages;
    screen = pkgs.writeShellScriptBin "screen" ''${builtins.readFile ./screen}'';
    bandw = pkgs.writeShellScriptBin "bandw" ''${builtins.readFile ./bandw}'';
    maintenance = pkgs.writeShellScriptBin "maintenance" ''${builtins.readFile ./maintenance}'';

in {
    options.modules.packages = { enable = mkEnableOption "packages"; };
    config = mkIf cfg.enable {
    	home.packages = with pkgs; [
          ripgrep ffmpeg tealdeer
          eza htop fzf
          pass gnupg bat
          unzip lowdown zk
          grim slurp slop
          imagemagick age libnotify
          git python3 lua zig 
          mpv firefox pqiv
          screen bandw maintenance
          wf-recorder anki-bin go docker minikube
          zoxide perl
          ntfs3g docker-compose vscode fd yazi tmux kubectl networkmanagerapplet 
          dotnetCorePackages.sdk_8_0_3xx jdk android-studio android-tools scrcpy 
          vlc discord lazygit xdg-desktop-portal-hyprland kdePackages.xwaylandvideobridge fzf 
          jetbrains.rider swaynotificationcenter 
          flutterPackages-source.stable cmake ninja pkg-config gtk3 clang
      ];
  };
}
