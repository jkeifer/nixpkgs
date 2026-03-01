{ config, pkgs, lib, shellAliases, ... }:

with lib;
let
  cfg = config.modules.shells.bash;
in {
  imports = [
    ./common.nix
  ];

  options.modules.shells.bash = {
    enable = mkEnableOption "bash shell configuration";
  };

  config = mkIf cfg.enable {
    modules.shells.defaultShell = mkOverride 110 pkgs.bash;

    programs.bash = {
      enable = true;
      shellAliases = shellAliases;
    };
  };
}
