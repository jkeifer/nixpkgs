{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.pkgs.darwin;
in {
  options.modules.pkgs.darwin = {
    enable = mkEnableOption "macOS-specific packages";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; lib.optionals stdenv.isDarwin [
      colima
      lima
      m-cli # useful macOS CLI commands
    ];
  };
}
