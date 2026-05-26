{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.pkgs.ai;
in {
  options.modules.pkgs.ai = {
    enable = mkEnableOption "CLI utilities for AI";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      claude-code
      gemini-cli
      github-copilot-cli
    ];
  };
}
