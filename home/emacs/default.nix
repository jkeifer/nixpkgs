{ config, lib, pkgs, spacemacs, ... }:

with lib;
let
  cfg = config.modules.emacs;
in {
  options.modules.emacs = {
    enable = mkEnableOption "emacs with spacemacs configuration";
  };

  config = mkIf cfg.enable {
    programs.emacs.enable = true;
    home.file.".emacs.d" = {
      source = spacemacs;
      recursive = true;
    };
    home.file.".spacemacs".source = ./spacemacs.el;
  };
}
