{
  # see the following sources
  #   https://github.com/malob/nixpkgs
  #   https://github.com/kclejeune/system/blob/master/flake.nix

  description = "jak system configs";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

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

    cookbook.url = "github:jkeifer/homebrew-cookbook";
  };

  outputs = inputs@{ self, darwin, home-manager, flake-utils, nix-homebrew, ... }:
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
        ./modules/users.nix
        ./modules/common
        ./modules/darwin
        ./modules/home-manager.nix
      ];

      # Shared module configuration for all NixOS systems
      nixosModules = [
        home-manager.nixosModules.home-manager
        ./modules/users.nix
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
          specialArgs = { inherit self inputs; };
        };

      # Helper to build NixOS systems with consistent configuration
      mkNixos = hostModule:
        nixosSystem {
          modules = nixosModules ++ [ hostModule commonConfig ];
          specialArgs = { inherit self inputs; };
        };

      # Helper to build home-manager configurations with consistent configuration
      # Uses builtins.currentSystem so configs work on whatever machine evaluates them.
      mkHome = hostDir:
        let
          pkgs = import inputs.nixpkgs-unstable {
            system = builtins.currentSystem;
            inherit (nixpkgsConfig) config overlays;
          };
        in homeManagerConfiguration {
          inherit pkgs;
          modules = [ hostDir ];
          extraSpecialArgs = { inherit self inputs; };
        };

      # Automatically discover host configurations from directories
      mkHostConfigs = dir: constructor:
        let
          entries = builtins.readDir dir;
          hosts = builtins.filter (name: entries.${name} == "directory" && name != "_common") (builtins.attrNames entries);
        in
          builtins.listToAttrs (map (host: {
            name = host;
            value = constructor (dir + "/${host}");
          }) hosts);
    in {
      darwinConfigurations = mkHostConfigs ./hosts/darwin mkDarwin;
      nixosConfigurations = mkHostConfigs ./hosts/nixos mkNixos;
      homeConfigurations = mkHostConfigs ./hosts/home-manager mkHome;

      overlays.default = import ./overlays inputs;

      # Validation checks -- run `nix flake check --no-build` to evaluate all configs
      # homeConfigurations use builtins.currentSystem so they can't be checked
      # in pure evaluation mode; validate them with `nix build .#homeConfigurations.<name>.activationPackage`
      checks = let
        # Map each darwin config's toplevel derivation into checks for its system
        darwinChecks = builtins.mapAttrs
          (name: cfg: cfg.config.system.build.toplevel)
          self.darwinConfigurations;

        # Map each nixos config's toplevel derivation
        nixosChecks = builtins.mapAttrs
          (name: cfg: cfg.config.system.build.toplevel)
          self.nixosConfigurations;

        # Group all checks by their target system
        groupBySystem = configs: getSystem:
          builtins.foldl' (acc: name:
            let
              sys = getSystem configs.${name};
            in acc // { ${sys} = (acc.${sys} or {}) // { ${name} = configs.${name}; }; }
          ) {} (builtins.attrNames configs);
      in
        groupBySystem darwinChecks (drv: drv.system)
        // groupBySystem nixosChecks (drv: drv.system);

  } // flake-utils.lib.eachSystem supportedSystems (system:
    let
      pkgs = import inputs.nixpkgs-unstable { inherit system; inherit (nixpkgsConfig) config overlays; };
    in {
      legacyPackages = pkgs;

      formatter = pkgs.nixfmt;

      devShells.default = pkgs.mkShell {
        name = "nixpkgs-dev";
        packages = with pkgs; [
          nixfmt
          statix
          deadnix
        ];
      };

      packages = {
        nixlify = pkgs.writeShellScriptBin "nixlify" ''
          exec ${self.outPath}/bin/nixlify "$@"
        '';
        nixdiff = pkgs.writeShellScriptBin "nixdiff" ''
          exec ${self.outPath}/bin/lib/nixdiff "$@"
        '';
      };
    }
  );
}
