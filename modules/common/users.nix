{ config, lib, pkgs, ... }:

with lib;
{
  options._.users = mkOption {
    type = types.attrsOf (types.submodule ({ name, config, ... }: {
      options = {
        username = mkOption {
          type = types.str;
          default = name;  # Defaults to the attribute name
          description = "System username for this user account";
          example = "jarrettk";
        };

        fullName = mkOption {
          type = types.str;
          description = "Full name of the user";
          example = "Jarrett Keifer";
        };

        gitEmail = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Default git email address";
        };

        gitName = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Default git user name";
        };

        trustedForNix = mkOption {
          type = types.bool;
          default = false;
          description = "Whether this user should be trusted for Nix operations";
        };

        shell = mkOption {
          type = types.nullOr types.package;
          default = null;
          description = ''
            User's login shell. If null, auto-detected from
            home-manager modules.shells.defaultShell
          '';
        };

        extraGroups = mkOption {
          type = types.listOf types.str;
          default = [];
          description = "Additional groups for this user (NixOS only). Include 'wheel' for sudo access.";
          example = [ "wheel" "docker" "networkmanager" ];
        };

        homeManager = mkOption {
          type = types.submodule {
            freeformType = types.attrsOf types.anything;
            options = {
              imports = mkOption {
                type = types.listOf types.unspecified;
                default = [];
                description = "Home-manager modules to import for this user";
              };
              config = mkOption {
                type = types.attrs;
                default = {};
                description = "Home-manager configuration for this user";
              };
            };
          };
          default = {};
          description = "Home-manager configuration for this user";
        };
      };
    }));
    default = {};
    description = "Custom user accounts to create with home-manager configuration";
  };

  config = {
    # Create system user accounts
    users.users = mapAttrs' (attrName: userCfg:
      let
        # Use the username option (which defaults to attrName but can be overridden)
        username = userCfg.username;
        # Auto-detect shell from evaluated home-manager config if not explicitly set
        detectedShell = config.home-manager.users.${username}.modules.shells.defaultShell or pkgs.bash;
        finalShell = if userCfg.shell != null then userCfg.shell else detectedShell;
      in nameValuePair username {
        description = userCfg.fullName;
        home = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
        shell = finalShell;
        trustedForNix = userCfg.trustedForNix;
      } // optionalAttrs (!pkgs.stdenv.isDarwin) {
        # NixOS-specific settings
        isNormalUser = true;  # use users.users directly for service accounts
        extraGroups = userCfg.extraGroups;
      }
    ) config._.users;

    # Create home-manager configurations
    home-manager.users = mapAttrs' (attrName: userCfg:
      nameValuePair userCfg.username ({ self, ... }: {
      imports = [
        # Always import shells/common.nix for defaultShell option (used by shell auto-detection)
        "${self}/home/shells/common.nix"
      ] ++ userCfg.homeManager.imports;

      config = mkMerge [
        # Apply git config if provided
        (mkIf (userCfg.gitEmail != null && userCfg.gitName != null) {
          modules.git = {
            # Auto-enable git when user config is provided
            enable = mkDefault true;
            user = {
              email = userCfg.gitEmail;
              name = userCfg.gitName;
            };
          };
        })

        # User's home-manager config
        userCfg.homeManager.config
      ];
    })) config._.users;
  };
}
