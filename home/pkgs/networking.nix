{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.pkgs.networking;
in {
  options.modules.pkgs.networking = {
    enable = mkEnableOption "networking tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      arping
      mtr
      netcat
      nmap
      tcpdump
    ];
  };
}
