{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.pkgs.workstation;
in {
  options.modules.pkgs.workstation = {
    enable = mkEnableOption "workstation tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      qrencode
      pandoc
    ];
  };
}
