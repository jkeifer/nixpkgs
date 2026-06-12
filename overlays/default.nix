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
    system = prev.stdenv.hostPlatform.system;
    inherit (nixpkgsConfig) config;
  };
  pkgs-stable = import inputs.nixpkgs-stable {
    system = prev.stdenv.hostPlatform.system;
    inherit (nixpkgsConfig) config;
  };

  # packages held back
  inherit (final.pkgs-stable)
  ;

  # packages from master
  inherit (final.pkgs-master)
    # TODO: remove once new model availability is stable and lands
    claude-code
  ;

  # flake input packages
  #nvim-plugins = import inputs.nixneovim.overlays.default;
  # none

} // optionalAttrs (prev.stdenv.hostPlatform.system == "aarch64-darwin") {
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
