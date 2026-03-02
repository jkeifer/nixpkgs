{ self, config, lib, pkgs, options, ... }:

with lib;
let
  workspaceDir = ./workspaces;
  workspaceFiles = builtins.readDir workspaceDir;
  availableWorkspaces = map (name: removeSuffix ".nix" name)
    (filter (name: hasSuffix ".nix" name) (attrNames workspaceFiles));
in {
  options._.jkeifer.workspaces = mkOption {
    type = types.listOf (types.enum availableWorkspaces);
    default = [];
    description = ''
      List of workspace names to enable for jkeifer user.
      Available workspaces: ${concatStringsSep ", " availableWorkspaces}
    '';
    example = [ "e84" "dev" ];
  };

  config = {
    _.users.jkeifer = {
      # username defaults to "jkeifer" but can be overridden per-host
      # For example: _.users.jkeifer.username = "jarrettk";

      fullName = "Jarrett Keifer";
      gitEmail = "jkeifer0@gmail.com";
      gitName = "Jarrett Keifer";
      trustedForNix = true;
      extraGroups = [ "wheel" ];  # sudo access on NixOS

      homeManager = {
        imports = [
          "${self}/home"
        ] ++ (
          map (name:
            (import (./workspaces + "/${name}.nix")) { directory = name; }
          ) config._.jkeifer.workspaces
        );

        config = {
          # User-specific config goes here
          # Host-specific module enables are in host configs
          # (e.g., hosts/darwin/_common/workstation.nix)
        };
      };
    };
  } // optionalAttrs (options ? darwin) {
    # Darwin-specific configuration
    homebrew.user = mkDefault config._.users.jkeifer.username;
  } // optionalAttrs (options ? nixos) {
    # NixOS-specific configuration
  };
}
