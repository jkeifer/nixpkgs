{ config, lib, pkgs, ... }:

{
  # Darwin-specific Nix settings
  nix = {
    extraOptions = lib.mkAfter (
      lib.optionalString (pkgs.system == "aarch64-darwin") ''
        extra-platforms = x86_64-darwin aarch64-darwin
      ''
    );
  };
}
