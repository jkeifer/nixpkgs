{ config, lib, pkgs, spacemacs, zi, ... }:

with lib;
let
  cfg = config.homeProfile;
in {
  options.homeProfile = {
    profile = mkOption {
      type = types.enum [ "base" "development" "workstation" ];
      default = "workstation";
      description = "Which home-manager profile to use";
    };

    workspaces = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          enable = mkEnableOption "this workspace" // { default = true; };
          directory = mkOption {
            type = types.str;
            default = "";
            description = "Directory name in home folder (relative to ~/). Defaults to workspace name if not specified.";
          };
        };
      });
      default = {};
      description = "Workspace configurations to enable";
      example = {
        e84 = {
          enable = true;
          directory = "e84";  # or "work/e84" for custom path
        };
      };
    };
  };

  config = let
    # Process workspaces: set default directory to workspace name if not specified
    enabledWorkspaces = filterAttrs (name: ws: ws.enable) cfg.workspaces;
    workspacesWithDefaults = mapAttrs (name: ws: {
      inherit (ws) enable;
      directory = if ws.directory != "" then ws.directory else name;
    }) enabledWorkspaces;

    # Generate workspace module imports with directory parameter
    # Each workspace is wrapped in a module that sets _module.args.directory
    workspaceModules = mapAttrsToList (name: ws: {
      _module.args.directory = ws.directory;
      imports = [ ../home/profiles/workspaces/${name}.nix ];
    }) workspacesWithDefaults;

  in {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      extraSpecialArgs = { inherit spacemacs zi; };
    };

    # Home-manager configuration for the user
    # Platform-specific additions (like darwin profile) are imported
    # in modules/darwin/home-manager.nix or modules/nixos/home-manager.nix
    home-manager.users.${config.user.name} = { ... }: {
      imports = [
        # User-specific data (git emails, etc.)
        ../home

        # Platform-agnostic profile
        ../home/profiles/${cfg.profile}.nix
      ] ++ workspaceModules;
    };
  };
}
