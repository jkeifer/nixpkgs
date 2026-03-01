{ config, lib, pkgs, ... }:

with lib;
{
  # Extend the users.users submodule to add custom options
  options.users.users = mkOption {
    type = types.attrsOf (types.submodule {
      options = {
        trustedForNix = mkOption {
          type = types.bool;
          default = false;
          description = "Whether this user should be trusted for Nix operations";
        };
      };
    });
  };
}
