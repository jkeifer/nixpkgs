{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.pkgs.fonts;
in {
  options.modules.pkgs.fonts = {
    enable = mkEnableOption "font packages";
  };

  config = mkIf cfg.enable {
    # Allow installing font packages
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      nerd-fonts.fira-code
    ];
  };
}
