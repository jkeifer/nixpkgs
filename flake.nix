{
  # see the following sources
  #   https://github.com/malob/nixpkgs
  #   https://github.com/kclejeune/system/blob/master/flake.nix

  description = "jak system configs";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-21.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-21.05";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-with-patched-kitty.url = "github:azuwis/nixpkgs/kitty";

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
    zinit = {
      url = "github:zdharma-continuum/zinit/master";
      flake = false;
    };
  };

  outputs = inputs@{ self, darwin, home-manager, flake-utils, spacemacs, zinit, ... }:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (home-manager.lib) homeManagerConfiguration;
      inherit (inputs.nixpkgs-unstable.lib) optionalAttrs singleton;

      nixpkgsConfig = rec {
        config = {
          allowUnsupportedSystem = true;
          allowUnfree = true;
          allowBroken = false;
        };
        overlays = self.overlays ++ singleton (
          # Sub in x86 version of packages that don't build on Apple Silicon yet
          final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            inherit (final.pkgs-x86)
              nix-index
            ;
          })
        );
      };

      supportedSystems = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];

      mkDarwinConfig = {
        username,
        hostname,
        system ? "x86_64-darwin",
        nixpkgs ? nixpkgsConfig,
        baseModules ?  [
          home-manager.darwinModules.home-manager
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
          specialArgs = { inherit spacemacs zinit; };
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
          specialArgs = { inherit spacemacs zinit; };
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
          }];
        };

        # config for github CI workflow
        github-ci = mkDarwinConfig {
          username = "runner";
          extraModules = [
            ({ lib, ... }: { homebrew.enable = lib.mkForce false; })
          ];
        };

      };

    # home-manager configurations
    homeConfigurations = {

      # Build and activate with `nix build .#vm.activationPackage; ./result/activate`
      vm = mkHomeConfig {
        username = "jak";
      };

    };

   overlays = with inputs; [
      (
        final: prev: ({
          # Add access to other versions of `nixpkgs`
          pkgs-master = import inputs.nixpkgs-master {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
          pkgs-stable = import inputs.nixpkgs-stable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };

          # flake input packages
          # none

        } // optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import inputs.nixpkgs-unstable { system = "x86_64-darwin"; inherit (nixpkgsConfig) config; };

          # Get Apple Silicon version of `kitty`
          # TODO: Remove when https://github.com/NixOS/nixpkgs/pull/137512 lands
          inherit (inputs.nixpkgs-with-patched-kitty.legacyPackages.aarch64-darwin) kitty;
        })
      )
    ];

  } // flake-utils.lib.eachSystem supportedSystems (system: {
      legacyPackages = import inputs.nixpkgs-unstable { inherit system; inherit (nixpkgsConfig) config overlays; };
  });
}
