{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.git;
in {
  options.modules.git = {
    enable = mkEnableOption "git configuration";

    user = {
      email = mkOption {
        type = types.str;
        description = "Default git email address";
        default = "";
      };
      name = mkOption {
        type = types.str;
        description = "Default git user name";
        default = "";
      };
    };

    workspaces = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          email = mkOption {
            type = types.str;
            description = "Git email for this workspace";
          };
          name = mkOption {
            type = types.str;
            description = "Git user name for this workspace";
          };
        };
      });
      default = {};
      description = "Git configurations for different workspace directories";
      example = {
        work = {
          email = "user@work.com";
          name = "Work User";
        };
      };
    };

    deltaEnable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable delta for enhanced diffs";
    };
  };

  config = mkIf cfg.enable {
    # Enhanced diffs
    programs.delta = {
      enable = cfg.deltaEnable;
      enableGitIntegration = cfg.deltaEnable;
    };

    # https://rycee.gitlab.io/home-manager/options.html#opt-programs.git.enable
    programs.git = {
      enable = true;

      settings = {
        user = {
          email = cfg.user.email;
          name = cfg.user.name;
        };
        diff.colorMoved = "default";
        init.defaultBranch = "main";
        pull.rebase = true;
        push.default = "simple";
      };

      ignores = [
        ".DS_Store"
        "_build/"
        "shell.nix"
        ".direnv/"
        ".envrc"
        "*.swp"
      ];

      # Generate includes from workspaces configuration
      includes = mapAttrsToList (dir: workspace: {
        condition = "gitdir:~/${dir}/";
        contents = {
          user.name = workspace.name;
          user.email = workspace.email;
        };
      }) cfg.workspaces;
    };
  };
}
