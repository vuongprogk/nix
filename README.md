# ❄️ NixOS dotfiles

*My configuration files for NixOS. Feel free to look around and copy!* 


## Info
- RAM usage on startup: ~180mb
- Package count: :package: 582
- Window manager: :herb: Hyprland
- Shell: :shell: zsh
- Editor: :pencil: neovim
- Browser: :fox_face: Firefox
- Other: dunst, swaybg, eww, wofi

## Commands to know
- Rebuild and switch the system configuration (in the config directory):
```
rebuild
``` 
OR
```
doas nixos-rebuild switch --flake .#yourComputer --fast
```

- Connect to wifi (replace stuff within brackets with your info)
```
iwctl --passphrase [passphrase] station [device] connect [SSID]
```

## Installation

** IMPORTANT: do NOT use my laptop.nix and/or desktop.nix! These files include settings that are specific to MY drives and they will mess up for you if you try to use them on your system. **

Please be warned that it may not work perfectly out of the box.
For best security, read over all the files to confirm there are no conflictions with your current system. 

Prerequisites:
- [NixOS installed and running](https://nixos.org/manual/nixos/stable/index.html#ch-installation)
- [Flakes enabled](https://nixos.wiki/wiki/flakes)
- Root access

Clone the repo and cd into it:

```bash
git clone https://github.com/vuongprogk/dotfiles-nix ~/.config/nixos && cd ~/.config/nixos
```

First, create a hardware configuration for your system:

```bash
sudo nixos-generate-config
```

You can then copy this to a the `hosts/` directory (note: change `yourComputer` with whatever you want):

```
mkdir hosts/yourComputer
cp /etc/nixos/hardware-configuration.nix ~/.config/nixos/hosts/yourComputer/
```

You can either add or create your own output in `flake.nix`, by following this template:
```nix
nixosConfigurations = {
    # Now, defining a new system is can be done in one line
    #                                Architecture   Hostname
    laptop = mkSystem inputs.nixpkgs "x86_64-linux" "laptop";
    desktop = mkSystem inputs.nixpkgs "x86_64-linux" "desktop";
    # ADD YOUR COMPUTER HERE! (feel free to remove mine)
    yourComputer = mkSystem inputs.nixpkgs "x86_64-linux" "yourComputer";
};
```

Next, create `hosts/yourComputer/user.nix`, a configuration file for your system for any modules you want to enable:
```nix
{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];
    config.modules = {
        # gui
        hyprland.enable = true;

        # cli
        nvim.enable = true;

        # system
        xdg.enable = true;
    };
}
```
The above config installs and configures hyprland, nvim, and xdg user directories. Each config is modularized so you don't have to worry about having to install the software alongside it, since the module does it for you. Every available module can be found in the `modules` directory.

Lastly, build the configuration with 

```bash
sudo nixos-rebuild switch --flake .#yourComputer
```

