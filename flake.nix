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
      inherit (inputs.nixpkgs-unstable.lib) mkDefault;
      inherit (inputs.nixos-unstable.lib) nixosSystem;

      nixpkgsConfig = rec {
        config = {
          allowUnsupportedSystem = true;
          allowUnfree = true;
          allowBroken = false;
        };
        overlays = [ self.overlays.default ];
      };

      # x86_64-darwin was dropped upstream in nixpkgs 26.11 (evaluating it now
      # throws); re-add it here only if an Intel Mac host is ever added.
      supportedSystems = [ "aarch64-darwin" "x86_64-linux" "aarch64-linux" ];

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
      # The host directory name doubles as the default hostname
      mkDarwin = name: hostModule:
        darwinSystem {
          modules = darwinModules ++ [
            hostModule
            commonConfig
            {
              networking.hostName = mkDefault name;
              networking.computerName = mkDefault name;
            }
          ];
          specialArgs = { inherit self inputs; };
        };

      # Helper to build NixOS systems with consistent configuration
      # The host directory name doubles as the default hostname
      mkNixos = name: hostModule:
        nixosSystem {
          modules = nixosModules ++ [
            hostModule
            commonConfig
            { networking.hostName = mkDefault name; }
          ];
          specialArgs = { inherit self inputs; };
        };

      # Helper to build home-manager configurations with consistent configuration
      # Uses builtins.currentSystem so configs work on whatever machine evaluates them.
      mkHome = _name: hostDir:
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
            value = constructor host (dir + "/${host}");
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
          (_name: cfg: cfg.config.system.build.toplevel)
          self.darwinConfigurations;

        # Map each nixos config's toplevel derivation
        nixosChecks = builtins.mapAttrs
          (_name: cfg: cfg.config.system.build.toplevel)
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

      # Single source of truth for the validations run by both CI
      # (`nix run .#ci`) and the git pre-commit hook the devShell installs.
      ciCheck = pkgs.writeShellApplication {
        name = "ci";
        runtimeInputs = [ pkgs.statix pkgs.deadnix ];
        text = ''
          # Evaluate every host config. --no-build so darwin/nixos toplevels
          # only need to *evaluate* on a linux runner; --impure so the
          # homeConfigurations' builtins.currentSystem resolves.
          nix flake check --no-build --all-systems --impure

          # Lint (statix reads ./statix.toml). --no-lambda-pattern-names keeps
          # idiomatic unused module args ({ config, lib, pkgs, ... }) passing.
          statix check .
          deadnix --fail --no-lambda-pattern-names .
        '';
      };
    in {
      legacyPackages = pkgs;

      formatter = pkgs.nixfmt;

      # `nix run .#ci` runs exactly what CI runs.
      apps = let app = { type = "app"; program = "${ciCheck}/bin/ci"; }; in {
        ci = app;
        default = app;
      };

      devShells.default = pkgs.mkShell {
        name = "nixpkgs-dev";
        packages = [ pkgs.nixfmt pkgs.statix pkgs.deadnix ciCheck ];

        # Install a pre-commit hook that runs the same checks as CI. Only
        # installs when absent, so it never clobbers an existing custom hook.
        shellHook = ''
          hook=.git/hooks/pre-commit
          if [ -d .git ] && [ ! -e "$hook" ]; then
            printf '#!/usr/bin/env bash\nexec nix run .#ci\n' > "$hook"
            chmod +x "$hook"
            echo "installed pre-commit hook -> nix run .#ci"
          fi
        '';
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
