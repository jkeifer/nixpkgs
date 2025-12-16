inputs:

let
  inherit (inputs.nixpkgs-unstable.lib) optionalAttrs;

  nixpkgsConfig = {
    config = {
      allowUnsupportedSystem = true;
      allowUnfree = true;
      allowBroken = false;
    };
  };
in

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

  # packages held back
  inherit (final.pkgs-stable)
  ;

  # packages from master
  inherit (final.pkgs-master)
    # TODO: remove this, waiting on a PR to land on unstable
    #       https://github.com/NixOS/nixpkgs/pull/450333
    awscli2
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
})
