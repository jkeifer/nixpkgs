{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.pkgs.core;
in {
  options.modules.pkgs.core = {
    enable = mkEnableOption "core CLI utilities";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      coreutils-full
      curl
      findutils
      gawk
      gnugrep
      gnused
      jq
      socat
      tree
      watch
      wget
      xz
    ];
  };
}
