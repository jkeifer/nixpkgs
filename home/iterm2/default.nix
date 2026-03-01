{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.iterm2;
in {
  options.modules.iterm2 = {
    enable = mkEnableOption "iTerm2 configuration";
  };

  config = mkIf cfg.enable {
    home.file.".iterm" = {
      source = ./.iterm;
    };
  };
}
