# ❄️ NixOS dotfiles

A modular and optimized NixOS configuration using flakes and home-manager.

## ✨ Features

- **Modular Design**: Each application has its own module for easy management
- **Wayland-first**: Hyprland, Waybar, Foot terminal, and other Wayland-native tools
- **Development Ready**: Pre-configured for multiple programming languages
- **Optimized Performance**: Efficient builds and clean module structure
- **Security Focused**: Hardened Firefox, firewall configuration, and secure defaults

## 🏗️ Structure

```
.
├── flake.nix              # Main flake configuration
├── lib/                   # Helper functions
├── hosts/                 # Host-specific configurations
│   ├── laptop/            # Laptop configuration
│   └── desktop/           # Desktop configuration
├── modules/               # Application modules
│   ├── system/            # System-level configuration
│   ├── gui/               # GUI applications (Firefox, Foot, etc.)
│   ├── cli/               # CLI tools (Neovim, Zsh, Git, etc.)
│   └── development/       # Development tools
├── overlays/              # Custom package overlays
└── scripts/               # Utility scripts
```

## 🚀 Quick Start

### Installation

```bash
git clone <this-repo> ~/.config/nixos && cd ~/.config/nixos
```

### Create Hardware Configuration

```bash
sudo nixos-generate-config
mkdir -p hosts/$(hostname)
cp /etc/nixos/hardware-configuration.nix hosts/$(hostname)/
```

### Configure User Modules

Create `hosts/$(hostname)/user.nix`:

```nix
{ config, lib, inputs, ...}:
{
  imports = [ ../../modules/default.nix ];
  config.modules = {
    # GUI applications
    firefox.enable = true;
    foot.enable = true;
    hyprland.enable = true;
    waybar.enable = true;

    # CLI tools
    nvim.enable = true;
    zsh.enable = true;
    git.enable = true;

    # System packages
    packages.enable = true;
  };
}
```

### Build and Apply

```bash
# Quick check for syntax errors
./scripts/check.sh

# Full build and optimization
./scripts/optimize.sh
```

## 🛠️ Development

Enter the development shell:

```bash
nix develop
```

This provides tools for Nix development:

- `nixd` - Nix language server
- `nixpkgs-fmt` - Code formatter
- `statix` - Linter
- `deadnix` - Dead code elimination

## 📦 Available Modules

### GUI Applications

- **Firefox**: Privacy-hardened browser with custom CSS
- **Foot**: Fast Wayland terminal
- **Hyprland**: Tiling window manager
- **Waybar**: Status bar with custom themes
- **Rofi**: Application launcher
- **Dunst**: Notification daemon

### CLI Tools

- **Neovim**: Text editor with sensible defaults
- **Zsh**: Shell with oh-my-posh and plugins
- **Git**: Version control with user configuration
- **Tmux**: Terminal multiplexer with Tokyo Night theme
- **Direnv**: Environment management

### Development

- **Rider**: JetBrains IDE
- **Node.js ecosystem**: npm, TypeScript, Bun
- **.NET**: SDK and runtime
- **Docker**: Container runtime
- **Languages**: Go, Rust, Python, Java

## 🎨 Customization

Each module can be enabled/disabled in your host's `user.nix`:

```nix
config.modules = {
  firefox.enable = true;      # Enable Firefox
  nvim.enable = false;        # Disable Neovim
  # ... other modules
};
```

## 🔧 Maintenance

### Update System

```bash
./scripts/optimize.sh
```

### Check for Issues

```bash
./scripts/check.sh
```

### Manual Commands

```bash
# Update flake inputs
nix flake update

# Garbage collection
nix-collect-garbage -d

# Optimize store
nix store optimise

# Rebuild system
sudo nixos-rebuild switch --flake .#$(hostname)
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Test your changes with `./scripts/check.sh`
4. Submit a pull request

## 📄 License

This configuration is released under the MIT License.

_My configuration files for NixOS. Feel free to look around and copy!_

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
