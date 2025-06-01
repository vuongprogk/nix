{ inputs, pkgs, config, ... }:

{
  home.stateVersion = "24.05";  # Use current stable version
  imports = [
    # GUI applications
    ./firefox
    ./foot
    ./dunst
    ./hyprland
    ./rofi
    ./waybar
    
    # CLI tools
    ./nvim
    ./zsh
    ./git
    ./gpg
    ./direnv
    ./tmux
    
    # Development
    ./rider
    
    # Packages
    ./packages
  ];
}
