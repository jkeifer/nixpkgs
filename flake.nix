{
  # see the following sources
  #   https://github.com/malob/nixpkgs
  #   https://github.com/kclejeune/system/blob/master/flake.nix

  description = "jak system configs";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    spacemacs = {
      url = "github:/syl20bnr/spacemacs/master";
      flake = false;
    };
    #comma = {
    #  url = "github:Shopify/comma";
    #  flake = false;
    #};
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    zi = {
      url = "github:z-shell/zi/main";
      flake = false;
    };

    nixneovim.url = "github:nixneovim/nixneovim";
  };

  outputs = inputs@{ self, darwin, home-manager, flake-utils, nix-homebrew, spacemacs, zi, ... }:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (home-manager.lib) homeManagerConfiguration;
      inherit (inputs.nixpkgs-unstable.lib) optionalAttrs singleton;
      inherit (inputs.nixos-unstable.lib) nixosSystem;

      nixpkgsConfig = rec {
        config = {
          allowUnsupportedSystem = true;
          allowUnfree = true;
          allowBroken = false;
        };
        overlays = [ self.overlays.default ];
      };

      supportedSystems = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" "aarch64-linux" ];

      # Shared module configuration for all Darwin systems
      darwinModules = [
        home-manager.darwinModules.home-manager
        nix-homebrew.darwinModules.nix-homebrew
        ./modules/common
        ./modules/darwin
        ./modules/home-manager.nix
      ];

      # Shared module configuration for all NixOS systems
      nixosModules = [
        home-manager.nixosModules.home-manager
        ./modules/common
        ./modules/nixos
        ./modules/home-manager.nix
      ];

      # Common configuration injected into all systems
      commonConfig = {
        nixpkgs = nixpkgsConfig;
        nix.registry.my.flake = self;
      };

      # Helper to build Darwin systems with consistent configuration
      mkDarwin = hostModule:
        darwinSystem {
          modules = darwinModules ++ [ hostModule commonConfig ];
          specialArgs = { inherit spacemacs zi; };
        };

      # Helper to build NixOS systems with consistent configuration
      mkNixos = hostModule:
        nixosSystem {
          modules = nixosModules ++ [ hostModule commonConfig ];
          specialArgs = { inherit spacemacs zi; };
        };

      # Helper to build home-manager configurations with consistent configuration
      mkHome = hostModule:
        homeManagerConfiguration {
          modules = [ hostModule ];
          extraSpecialArgs = { inherit spacemacs zi; };
        };
    in {
      # MacOS configurations
      darwinConfigurations = {
        acamapichtli = mkDarwin ./hosts/darwin/acamapichtli;
        toltecal = mkDarwin ./hosts/darwin/toltecal;
        jkeifer-MacBook-Pro = mkDarwin ./hosts/darwin/jkeifer-MacBook-Pro;
        oxomoco = mkDarwin ./hosts/darwin/oxomoco;
        github-ci-darwin = mkDarwin ./hosts/darwin/github-ci-darwin;
      };

      nixosConfigurations = {
        huijatoo = mkNixos ./hosts/nixos/huijatoo;
      };

      # home-manager configurations
      homeConfigurations = {
        # Build and activate with `nix build .#homeConfigurations.vm.activationPackage; ./result/activate`
        vm = mkHome ./hosts/home-manager/vm;
      };

      overlays.default = import ./overlays inputs;


  } // flake-utils.lib.eachSystem supportedSystems (system: {
    legacyPackages = import inputs.nixpkgs-unstable { inherit system; inherit (nixpkgsConfig) config overlays; };
  });
}
