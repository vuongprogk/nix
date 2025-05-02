{ config, lib, inputs, ...}:

{
  imports = [ ../../modules/default.nix ];
  config.modules = {
    # gui
    firefox.enable = true;
    foot.enable = true;
    dunst.enable = true;
    hyprland.enable = true;
    rofi.enable = true;

    # cli
    nvim.enable = true;
    zsh.enable = true;
    git.enable = true;
    gpg.enable = true;
    direnv.enable = true;

    # system
    packages.enable = true;
  };
}
