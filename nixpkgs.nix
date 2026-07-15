# Legacy (non-flake) entry point: a nixpkgs instance matching the flake's
# primary input, with this repo's overlay applied. Usable from nix-shell
# or nix-build via flake-compat, e.g.:
#   nix-shell -p '(import ./nixpkgs.nix {}).somePackage'
{
  system ? builtins.currentSystem,
  config ? {},
  overlays ? [ (import ./default.nix).overlays.default ]
}:
  import (import ./default.nix).inputs.nixpkgs-unstable { inherit system config overlays; }
