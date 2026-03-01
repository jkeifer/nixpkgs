{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.htop;
in {
  options.modules.htop = {
    enable = mkEnableOption "htop (interactive process viewer)";

    showProgramPath = mkOption {
      type = types.bool;
      default = true;
      description = "Show program path in htop";
    };
  };

  config = mkIf cfg.enable {
    # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
    programs.htop = {
      enable = true;
      settings.show_program_path = cfg.showProgramPath;
    };
  };
}
