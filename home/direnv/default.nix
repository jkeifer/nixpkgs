{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.direnv;
in {
  options.modules.direnv = {
    enable = mkEnableOption "direnv configuration";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
      enable = true;
      nix-direnv.enable = true;
      stdlib = builtins.readFile ./direnvrc.sh;
    };
  };
}
