{ self, ... } @ inputs: name: system: 
  inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs self; };
    modules = [
      { networking.hostName = name; }
      ../modules/system/configuration.nix
      (../. + "/hosts/${name}/hardware-configuration.nix")
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useUserPackages = true;
          useGlobalPkgs = true;
          extraSpecialArgs = { inherit inputs self; };
          users.ace = import (../. + "/hosts/${name}/user.nix");
        };
        nixpkgs.overlays = [
          inputs.nur.overlays.default
          (import ../overlays)
        ];
      }
    ];
  }
