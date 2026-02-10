{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.tmp;
in {
  options.modules.tmp = {
    enable = mkEnableOption "tmp directory and screenshot management";

    screenshotPath = mkOption {
      type = types.str;
      default = "~/tmp/screenshots";
      description = "Path for macOS screenshots";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.file.tmp = {
        source = ./skel;
        recursive = true;
      };
    })

    (mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
      # Darwin-specific: Set screenshot location
      targets.darwin.defaults."com.apple.screencapture".location = cfg.screenshotPath;
    })
  ];
}
