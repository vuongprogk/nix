{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "21.03";
    imports = [
      # gui
      ./firefox
      ./foot
      ./dunst
      ./hyprland
      ./rofi
      ./nvim
      ./zsh
      ./git
      ./gpg
      ./direnv
	    ./packages
      ./rider
      ./waybar
    ];
}
