{ config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.modules.gribe;
in {
  imports = [ inputs.cookbook.homeManagerModules.default ];

  options.modules.gribe = {
    enable = mkEnableOption "gribe (transgribe audio transcription CLI + Claude skill)";
  };

  config = mkIf cfg.enable {
    programs.gribe = {
      enable = true;
      installSkill = true;
      settings = {
        default-model = "parakeet-v3";
        default-language = "en-US";
      };
    };
  };
}
