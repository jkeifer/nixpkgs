{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.bat;
in {
  options.modules.bat = {
    enable = mkEnableOption "bat (cat clone with syntax highlighting)";
  };

  config = mkIf cfg.enable {
    # https://rycee.gitlab.io/home-manager/options.html#opt-programs.bat.enable
    programs.bat = {
      enable = true;
    };
  };
}
