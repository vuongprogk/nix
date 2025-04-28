{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "21.03";
    imports = [
      # gui
      ./firefox
      ./foot
      ./dunst
      ./hyprland
      ./wofi
      ./nvim
      ./zsh
      ./git
      ./gpg
      ./direnv
      ./xdg
	    ./packages
    ];
}
