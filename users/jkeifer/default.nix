{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.jkeifer;
  mkUser = import ../../lib/mkUser.nix;

  # Dynamically discover available workspaces from the workspaces directory
  workspaceDir = ./workspaces;
  workspaceFiles = builtins.readDir workspaceDir;
  availableWorkspaces = map (name: removeSuffix ".nix" name)
    (filter (name: hasSuffix ".nix" name) (attrNames workspaceFiles));

  # Import workspace files as functions and call them with directory parameter
  workspaceModules = map (name:
    (import (./workspaces + "/${name}.nix")) { directory = name; }
  ) cfg.workspaces;

in {
  # Import this module to create the jkeifer user account
  # Override options as needed per-host

  options.jkeifer = {
    username = mkOption {
      type = types.str;
      default = "jkeifer";
      description = "System username for this user account";
      example = "jarrettk";
    };

    workspaces = mkOption {
      type = types.listOf (types.enum availableWorkspaces);
      default = [];
      description = ''
        List of workspace names to enable.
        Available workspaces: ${concatStringsSep ", " availableWorkspaces}
      '';
      example = [ "dev" "e84" ];
    };
  };

  imports = [
    (mkUser {
      username = cfg.username;
      fullName = "Jarrett Keifer";
      gitEmail = "jkeifer0@gmail.com";
      gitName = "Jarrett Keifer";
      trustedForNix = true;
    })
  ];

  config = {
    home-manager.users.${cfg.username} = {
      imports = workspaceModules;
    };
  } // optionalAttrs (options ? darwin) {
    # Darwin-specific configuration
    darwin.homebrewUser = mkDefault cfg.username;
  } // optionalAttrs (options ? nixos) {
    # NixOS-specific configuration
  };
}
