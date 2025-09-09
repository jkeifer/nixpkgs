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
        overlays = [ self.overlay ];
      };

      supportedSystems = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" "aarch64-linux" ];

      mkDarwinConfig = {
        username,
        hostname,
        system ? "x86_64-darwin",
        nixpkgs ? nixpkgsConfig,
        baseModules ? [
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          ./modules/darwin
          ./modules/home-manager.nix
        ],
        extraModules ? [ ]
      }:
        darwinSystem {
          inherit system;
          modules = baseModules
            ++ extraModules
            ++ [{
              nixpkgs = nixpkgsConfig;
              nix.registry.my.flake = self;
              user = {
                enable = true;
                name = username;
              };
              networking.computerName = hostname;
              networking.hostName = hostname;
            }];
          specialArgs = { inherit spacemacs zi; };
        };

      mkHomeConfig = {
        username,
        system ? "x86_64-linux",
        nixpkgs ? nixpkgsConfig,
        baseModules ? [ ./home ],
        extraModules ? [ ]
      }:
        homeManagerConfiguration rec {
          inherit system username;
          homeDirectory = "/home/${username}";
          configuration = {
            imports = baseModules ++ extraModules;
          };
          specialArgs = { inherit spacemacs zi; };
        };

      mkNixosConfig = {
        username,
        hostname,
        system ? "x86_64-linux",
        nixpkgs ? nixpkgsConfig,
        baseModules ? [
          home-manager.nixosModules.home-manager
          ./modules/nixos
        ],
        extraModules ? [],
      }:
        nixosSystem {
          inherit system;
          modules = baseModules
            ++ [ ./modules/hardware/${hostname}.nix ]
            ++ extraModules
            ++ [{
              nixpkgs = nixpkgsConfig;
              nix.registry.my.flake = self;
              user = {
                enable = true;
                name = username;
              };
              networking.hostName = hostname;
            }];
          specialArgs = { inherit spacemacs zi; };
        };
    in {
      # MacOS configurations
      darwinConfigurations = {

        # real system configs
        acamapichtli = mkDarwinConfig {
          username = "jarrettk";
          hostname = "acamapichtli";
          extraModules = [{
            networking.knownNetworkServices = [
              "Wi-Fi"
              "USB 10/100/1000 LAN"
            ];
          }];
        };

        toltecal = mkDarwinConfig {
          username = "jkeifer";
          hostname = "toltecal";
          system   = "aarch64-darwin";
          extraModules = [{
            networking.knownNetworkServices = [
              "Wi-Fi"
              "USB 10/100/1000 LAN"
            ];
            homebrew.casks = [
              "google-chrome"
              "qgis"
              "slack"
              "zoom"
            ];
          }];
        };

        jkeifer-MacBook-Pro = mkDarwinConfig {
          username = "jkeifer";
          hostname = "jkeifer-MacBook-Pro";
          system   = "aarch64-darwin";
          extraModules = [{
            networking.knownNetworkServices = [
              "Wi-Fi"
              "USB 10/100/1000 LAN"
            ];
            homebrew.casks = [
              "google-chrome"
              "orion"
              "qgis"
              "slack"
              "zoom"
            ];
            ids.gids.nixbld = 350;
          }];
        };

        oxomoco = mkDarwinConfig {
          username = "jkeifer";
          hostname = "oxomoco";
          system   = "aarch64-darwin";
          extraModules = [{
            networking.knownNetworkServices = [
              "Wi-Fi"
              "USB 10/100/1000 LAN"
            ];
            homebrew.masApps = {
              msRDP = 1295203466;
            };
            homebrew.casks = [
              "google-chrome"
              "zoom"
            ];
          }];
        };

        # config for github CI workflow
        github-ci-darwin = mkDarwinConfig {
          username = "runner";
          extraModules = [
            ({ lib, ... }: { homebrew.enable = lib.mkForce false; })
          ];
        };

      };

      nixosConfigurations = {
        "huijatoo" = mkNixosConfig {
          username = "jkeifer";
          hostname = "huijatoo";
          system = "aarch64-linux";
          extraModules = [{}];
        };
      };

      # home-manager configurations
      homeConfigurations = {

        # Build and activate with `nix build .#vm.activationPackage; ./result/activate`
        vm = mkHomeConfig {
          username = "jak";
        };

      };

   overlay = final: prev: ({
        # Add access to other versions of `nixpkgs`
        pkgs-master = import inputs.nixpkgs-master {
          inherit (prev.stdenv) system;
          inherit (nixpkgsConfig) config;
        };
        pkgs-stable = import inputs.nixpkgs-stable {
          inherit (prev.stdenv) system;
          inherit (nixpkgsConfig) config;
        };

        # packages held back
        inherit (final.pkgs-stable)
        ;

        # flake input packages
        #nvim-plugins = import inputs.nixneovim.overlays.default;
        # none

      } // optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
        # Add access to x86 packages system is running Apple Silicon
        pkgs-x86 = import inputs.nixpkgs-unstable {
          system = "x86_64-darwin";
          inherit (nixpkgsConfig) config;
        };

        # packages that don't yet build on aarch64-darwin
        inherit (final.pkgs-x86)
          #nix-index
        ;
      });


  } // flake-utils.lib.eachSystem supportedSystems (system: {
    legacyPackages = import inputs.nixpkgs-unstable { inherit system; inherit (nixpkgsConfig) config overlays; };
  });
}
