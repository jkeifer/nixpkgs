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
      settings = {
        "*github.com" = {
          IdentityFile = "~/.ssh/id_github";
          IdentitiesOnly = true;
        };

        "*repo.element84.com" = {
          IdentityFile = "~/.ssh/id_gitlab";
          IdentitiesOnly = true;
        };

        "*.bnd *.bvn" = {
          HostName = "%h.whyiseverythingalreadytaken.com";
          IdentityFile = "~/.ssh/id_wieat";
          IdentitiesOnly = true;
        };

        "*" = {
          ForwardAgent = false;
          Compression = true;
          ServerAliveInterval = 0;
          ServerAliveCountMax = 3;
          ControlMaster = "auto";
          ControlPath = "${tmpdir}/%C";
          ControlPersist = "600";
          HashKnownHosts = true;
          UserKnownHostsFile = "${config.home.homeDirectory}/.ssh/known_hosts";
          IgnoreUnknown = "UseKeychain";
          UseKeychain = "yes";
          AddKeysToAgent = "yes";
        };
      };
    };
  };
}
