{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.ssh;
  tmpdir = "~/tmp/ssh";
in {
  options.modules.ssh = {
    enable = mkEnableOption "ssh configuration";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      # interesting config examples:
      # https://github.com/jwiegley/nix-config/blob/master/config/home.nix
      matchBlocks = {
        github = {
          host = "*github.com";
          identityFile = "~/.ssh/id_github";
          identitiesOnly = true;
        };

        repo-element84 = {
          host = "*repo.element84.com";
          identityFile = "~/.ssh/id_gitlab";
          identitiesOnly = true;
        };

        internal = {
          host = "*.bnd *.bvn";
          hostname = "%h.whyiseverythingalreadytaken.com";
          identityFile = "~/.ssh/id_wieat";
          identitiesOnly = true;
        };

        "*" = {
          forwardAgent = false;
          compression = true;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          controlMaster  = "auto";
          controlPath    = "${tmpdir}/%C";
          controlPersist = "600";
          hashKnownHosts = true;
          userKnownHostsFile = "${config.home.homeDirectory}/.ssh/known_hosts";
          extraOptions = {
            UseKeychain    = "yes";
            AddKeysToAgent = "yes";
            IgnoreUnknown  = "UseKeychain";
          };
        };
      };
    };
  };
}
