{ config, pkgs, inputs,lib, ... }:

{
    # Remove unecessary preinstalled packages
    environment.defaultPackages = [ ];
    services.xserver.desktopManager.xterm.enable = false;
    programs.zsh.enable = true;

    virtualisation.docker.enable = true;
    # Laptop-specific packages (the other ones are installed in `packages.nix`)
    environment.systemPackages = with pkgs; [
        acpi tlp git
    ];

    # Install fonts
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono 
        roboto
        openmoji-color
        cascadia-code
      ];

      fontconfig = {
        enable = true;
        hinting.autohint = true;
        defaultFonts = {
          emoji = [ "OpenMoji Color" ];
        };
      };
    };


    # Wayland stuff: enable XDG integration, allow sway to use brillo
    xdg = {
        portal = {
            enable = true;
            extraPortals = with pkgs; [
                xdg-desktop-portal-wlr
                xdg-desktop-portal-gtk
            ];
        };
    };

    # Nix settings, auto cleanup and enable flakes
    nix = {
        settings.auto-optimise-store = true;
        settings.allowed-users = [ "ace" ];
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
        };
        extraOptions = ''
            experimental-features = nix-command flakes
            keep-outputs = true
            keep-derivations = true
        '';
    };

    # Boot settings: clean /tmp/, latest kernel and enable bootloader
    boot = {
        tmp.cleanOnBoot = true;
        loader = {
        systemd-boot.enable = true;
        systemd-boot.editor = false;
        efi.canTouchEfiVariables = true;
        timeout = 0;
        };
    };

    # Set up locales (timezone and keyboard layout)
    time.timeZone = "Asia/Ho_Chi_Minh";
    i18n.extraLocaleSettings = {
	    LC_ADDRESS = "vi_VN";
	    LC_IDENTIFICATION = "vi_VN";
	    LC_MEASUREMENT = "vi_VN";
	    LC_MONETARY = "vi_VN";
	    LC_NAME = "vi_VN";
	    LC_NUMERIC = "vi_VN";
	    LC_PAPER = "vi_VN";
	    LC_TELEPHONE = "vi_VN";
	    LC_TIME = "vi_VN";
	  };
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
    };
    i18n.inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = with pkgs; [
        fcitx5-bamboo
        fcitx5-gtk
      ];
      fcitx5.waylandFrontend = true;
    };

    # Set up user and enable sudo
    users.users.ace= {
        isNormalUser = true;
        extraGroups = [ "input" "wheel" "docker"];
        shell = pkgs.zsh;
    };

    # Set up networking and secure it
    networking = {
      wireless.iwd.enable = true;
      wireless.enable = false;
    networkmanager.enable = false;
      wireless.iwd.settings = {
        General = {
          EnableNetworkConfiguration = true;
        };
        Network = {
          EnableIPv6 = true;
        };
        Scan = {
          DisablePeriodicScan = true;
        };
        Settings = {
          AutoConnect = true;
        };
      };
      firewall = {
          enable = true;
          # allowedTCPPorts = [ 443 80 ];
          # allowedUDPPorts = [ 443 80 44857 ];
          allowPing = false;
      };
      useDHCP = true;
    };
    # Set environment variables
    environment.variables = {
        NIXOS_CONFIG = "$HOME/.config/nixos/configuration.nix";
        NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
        XDG_DATA_HOME = "$HOME/.local/share";
        PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
        GTK_RC_FILES = "$HOME/.local/share/gtk-1.0/gtkrc";
        GTK2_RC_FILES = "$HOME/.local/share/gtk-2.0/gtkrc";
        MOZ_ENABLE_WAYLAND = "1";
        EDITOR = "nvim";
        DIRENV_LOG_FORMAT = "";
        ANKI_WAYLAND = "1";
        DISABLE_QT5_COMPAT = "0";
        CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome-stable";
    };
    environment.sessionVariables = lib.mkDefault {
      GTK_THEME = "Adwaita-dark";
      GTK_APPLICATION_PREFER_DARK_THEME = "1";
      XMODIFIERS = "@im=fcitx";
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      INPUT_METHOD = "fcitx";
    };

    # # Security disable sudo and enable doas which act like sudo but is more secure
    security = {
        sudo.enable = true;
        doas = {
          enable = true;
          extraRules = [
            {
              users = [ "ace" ];
              keepEnv = true;
              persist = true;
            }
          ];
        };
    };

    # Enable the X11 windowing system.
  services.xserver.enable = true;
  programs.nix-ld.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true; 
    hardware = {
        bluetooth.enable = true;
        graphics = {
            enable = true;
        };
    };
  # Input
  services.libinput.enable = true;

  # Hyprland dependencies (especially if you're not using GDM)
  programs.hyprland.enable = true;
  nixpkgs.config.allowUnfree = true;
  boot.supportedFilesystems = [ "ntfs" ];
  hardware.enableAllFirmware = true;
  hardware.firmware = with pkgs; [
    linux-firmware
  ];
  services.gnome.gnome-keyring.enable = true;

    # Do not touch
  system.stateVersion = "24.05";
}
