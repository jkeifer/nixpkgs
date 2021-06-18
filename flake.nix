{
  # see the following sources
  #   https://github.com/malob/nixpkgs
  #   https://github.com/kclejeune/system/blob/master/flake.nix

  description = "jak system configs";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-21.05";

    spacemacs = {
      url = "github:/syl20bnr/spacemacs/master";
      flake = false;
    };
    comma = {
      url = "github:Shopify/comma";
      flake = false;
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, stable, darwin, home-manager, flake-utils, ... }:
    let
      overlays = [ ];

      inherit (darwin.lib) darwinSystem;
      inherit (home-manager.lib) homeManagerConfiguration;

      mkDarwinConfig = {
        username,
        hostname,
        system ? "x86_64-darwin",
        baseModules ?  [
          home-manager.darwinModules.home-manager
          ./modules/darwin
        ],
        extraModules ? [ ]
      }:
        darwinSystem {
          #inherit system;
          modules = baseModules
            ++ extraModules
            ++ [{ nixpkgs.overlays = overlays; }]
            ++ [{
              config.user = {
                enable = true;
                name = username;
              };
              config.networking.computerName = hostname;
              config.networking.hostName = hostname;
            }];
          specialArgs = { inherit inputs; };
        };

      mkHomeConfig = {
        username,
        system ? "x86_64-linux",
        baseModules ? [ ./home ],
        extraModules ? [ ]
      }:
        homeManagerConfiguration rec {
          inherit system username;
          homeDirectory = "/home/${username}";
          configuration = {
            imports = baseModules ++ extraModules
              ++ [{ nixpkgs.overlays = overlays; }];
          };
          specialArgs = { inherit inputs; };
        };
    in {
      # MacOS configurations
      darwinConfigurations = {

        # basic bootstrap config for new systems
        bootstrap = darwinSystem {
          modules = [ ./darwin/bootstrap.nix nixpkgs ];
        };

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
  };
}
