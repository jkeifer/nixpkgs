{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.github;
in {
  options.modules.github = {
    enable = mkEnableOption "github cli configuration";
  };

  config = mkIf cfg.enable {
    # GitHub CLI
    # https://rycee.gitlab.io/home-manager/options.html#opt-programs.gh.enable
    # Aliases config imported in flake.
    programs.gh = {
      enable = true;
      settings.gitProtocol = "ssh";
    };
  };
}
