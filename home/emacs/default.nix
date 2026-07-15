{ config, lib, pkgs, inputs, ... }:

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
      source = inputs.spacemacs;
      recursive = true;
    };
    home.file.".spacemacs".source = ./spacemacs.el;
  };
}
