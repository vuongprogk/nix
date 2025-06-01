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
  };

  # All outputs for the system (configs)
  outputs = { self, nixpkgs, ... }@inputs:
    let
      inherit (self) outputs;
      lib = import ./lib inputs;
    in
    {
      nixosConfigurations = {
        laptop = lib.mkSystem "laptop" "x86_64-linux";
        desktop = lib.mkSystem "desktop" "x86_64-linux";
      };

      # Development shell for working on the configuration
      devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        packages = with nixpkgs.legacyPackages.x86_64-linux; [
          nixd
          nil
          nixpkgs-fmt
          statix
          deadnix
        ];
        shellHook = ''
          echo "🎯 NixOS Configuration Development Environment"
          echo "Available tools:"
          echo "  - nixd: Language server for Nix"
          echo "  - nil: Alternative Nix language server" 
          echo "  - nixpkgs-fmt: Nix code formatter"
          echo "  - statix: Nix linter"
          echo "  - deadnix: Dead code elimination"
          echo ""
          echo "Run './scripts/optimize.sh' to rebuild and optimize"
        '';
      };
    };
}
