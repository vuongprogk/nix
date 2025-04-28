{
  description = "NixOS configuration";

  # All inputs for the system
  inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

      home-manager = {
          url = "github:nix-community/home-manager";
          inputs.nixpkgs.follows = "nixpkgs";
      };

      nur = {
          url = "github:nix-community/NUR";
          inputs.nixpkgs.follows = "nixpkgs";
      };
      ibus-bamboo = {
        url = "github:BambooEngine/ibus-bamboo";
      };
  };

  # All outputs for the system (configs)
  outputs = { self, home-manager, nixpkgs, nur,ibus-bamboo, ... }@inputs: 
      let
          inherit (self) outputs;
          system = "x86_64-linux"; #current system
          pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          lib = nixpkgs.lib;

          # This lets us reuse the code to "create" a system
          # Credits go to sioodmy on this one!
          # https://github.com/sioodmy/dotfiles/blob/main/flake.nix
          mkSystem = pkgs: system: hostname:
              pkgs.lib.nixosSystem {
                  system = system;
                  modules = [
                      { networking.hostName = hostname; }
                      # General configuration (users, networking, sound, etc)
                      ./modules/system/configuration.nix
                      ./modules/ibus/default.nix
                      # Hardware config (bootloader, kernel modules, filesystems, etc)
                      # DO NOT USE MY HARDWARE CONFIG!! USE YOUR OWN!!
                      (./. + "/hosts/${hostname}/hardware-configuration.nix")
                      home-manager.nixosModules.home-manager
                      {
                          home-manager = {
                              useUserPackages = true;
                              useGlobalPkgs = true;
                              extraSpecialArgs = {  inherit inputs outputs system; };
                              # Home manager config (configures programs like firefox, zsh, eww, etc)
                              users.ace = (./. + "/hosts/${hostname}/user.nix");
                          };
                          nixpkgs.overlays = [
                              # Add nur overlay for Firefox addons
                              nur.overlays.default
                              (import ./overlays)
                          ];
                      }
                  ];
                  specialArgs = { inherit inputs outputs system; };
              };

      in {
          nixosConfigurations = {
              # Now, defining a new system is can be done in one line
              #                                Architecture   Hostname
              laptop = mkSystem inputs.nixpkgs "x86_64-linux" "laptop";
              desktop = mkSystem inputs.nixpkgs "x86_64-linux" "desktop";
          };
  };
}
