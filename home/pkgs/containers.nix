{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.pkgs.containers;
in {
  options.modules.pkgs.containers = {
    enable = mkEnableOption "CLI utilities for containerization";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      docker
      podman
    ];
  };
}
