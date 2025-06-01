{ config, pkgs, lib, ... }:

{
    imports = [
      ./disk.nix
    ];

    # Environment configuration
    environment = {
      # Remove unecessary preinstalled packages
      defaultPackages = [ ];
      # Laptop-specific packages (the other ones are installed in `packages.nix`)
      systemPackages = with pkgs; [
        acpi tlp git flatpak
      ];
      # Set environment variables
      variables = {
        NIXOS_CONFIG = "$HOME/.config/nixos/configuration.nix";
        NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
        XDG_DATA_HOME = "$HOME/.local/share";
        PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
        EDITOR = "nvim";
        DIRENV_LOG_FORMAT = "";
        ANKI_WAYLAND = "1";
        DISABLE_QT5_COMPAT = "0";
        CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome-stable";
      };
      sessionVariables = lib.mkForce {
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        T_QPA_PLATFORM = "wayland";
        GDK_BACKEND = "wayland";
        WLR_NO_HARDWARE_CURSORS = "1";
        GTK_THEME = "Adwaita-dark";
        GTK_APPLICATION_PREFER_DARK_THEME = "1";
        XMODIFIERS = "@im=fcitx";
        QT_IM_MODULES="wayland;fcitx;ibus";
        INPUT_METHOD = "fcitx";
      };
    };
    # XDG Desktop Portal configuration for screen sharing
    xdg = {
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland
        ];
      };
    };
    # Services configuration
    services = {
      xserver = {
        enable = true;
        desktopManager = {
          xterm.enable = false;
          runXdgAutostartIfNone = true;
        };
      };
      flatpak.enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true; 
      libinput.enable = true;
      fprintd.enable = true;
      gnome.gnome-keyring.enable = true;
      dbus.enable = true;
      # PipeWire configuration for screen sharing
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };
      nginx = {
        enable = true;
        virtualHosts."smartedu.com" = {
          root = "/var/www"; # Optional, but recommended
          listen = [ { addr = "0.0.0.0"; port = 80; } ];
          locations."/" = {
            proxyPass = "http://127.0.0.1:8080";
            proxyWebsockets = true; # Optional: enable WebSocket proxying
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };
        };
      };
    };

    # Programs configuration
    programs = {
      zsh.enable = true;
      nix-ld.enable = true;
      hyprland.enable = true;
    };

    virtualisation.docker.enable = true;

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
    i18n = {
      extraLocaleSettings = {
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
      defaultLocale = "en_US.UTF-8";
      inputMethod = {
        type = "fcitx5";
        enable = true;
        fcitx5.addons = with pkgs; [
          fcitx5-bamboo
          fcitx5-gtk
          qt6Packages.fcitx5-qt
          fcitx5-configtool
        ];
        fcitx5.waylandFrontend = true;
      };
    };

    console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
    };

    # Set up user and enable sudo
    users.users.ace= {
        isNormalUser = true;
        extraGroups = [ "input" "wheel" "docker"];
        shell = pkgs.zsh;
    };

    # Set up networking and secure it
    networking = {
      wireless = {
        iwd = {
          enable = true;
          settings = {
            General.EnableNetworkConfiguration = true;
            Network.EnableIPv6 = true;
            Scan.DisablePeriodicScan = false;
            Settings.AutoConnect = true;
          };
        };
        enable = false;
      };
      networkmanager.enable = false;
      firewall = {
        enable = true;
        allowPing = false;
      };
      useDHCP = true;
      extraHosts = ''
        127.0.0.1 smartedu.com
      '';
    };

    # Security disable sudo and enable doas which act like sudo but is more secure
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

    # Hardware configuration
    hardware = {
        bluetooth.enable = true;
        graphics = {
            enable = true;
        };
        enableAllFirmware = true;
        firmware = with pkgs; [
            linux-firmware
        ];
    };

    # Security configuration
    security.pam.services = {
        sudo.fprintAuth = true;
        gdm.fprintAuth = true; # For GNOME Display Manager
    };

    # System configuration
    nixpkgs.config.allowUnfree = true;
    boot.supportedFilesystems = [ "ntfs" ];

    # Do not touch
  system.stateVersion = "24.05";
}
