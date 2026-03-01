{ config, pkgs, lib, zi, shellAliases, ... }:

with lib;
let
  cfg = config.modules.shells.zsh;
  functions = builtins.concatStringsSep
    "\n"
    (
      builtins.map
        (f: builtins.readFile (./functions + ("/" + f)))
        (
          builtins.attrNames (
            pkgs.lib.attrsets.filterAttrs
              (k: v: v == "regular" || v == "symlink")
              (builtins.readDir ./functions)
          )
        )
    );
in {
  imports = [
    ./common.nix
  ];

  options.modules.shells.zsh = {
    enable = mkEnableOption "zsh shell configuration";
  };

  config = mkIf cfg.enable {
    modules.shells.defaultShell = mkOverride 90 pkgs.zsh;

    home.packages = [ zi ];

    xdg.configFile."zi/bin" = {
      source = zi;
      recursive = true;
    };

    xdg.configFile."zsh/p10k.zsh".text = builtins.readFile ./p10k.zsh;

    programs.zsh = {
      enable = true;
      enableCompletion = false;
      dotDir = "${config.xdg.configHome}/zsh";

      history = {
        expireDuplicatesFirst = true;
        extended = true;
        ignorePatterns = [
          "rm *"
          "kill *"
          "pkill *"
        ];
        ignoreSpace = true;
        share = false;
      };

      initContent = ''
        typeset -Ag ZI
        typeset -gx ZI[HOME_DIR]="''${HOME}/.config/zi"
        typeset -gx ZI[BIN_DIR]="''${HOME}/.config/zi/bin"
        source "''${HOME}/.config/zi/bin/zi.zsh"
        ${functions}
        ${builtins.readFile ./config.zsh}
      '';

      shellAliases = shellAliases;
    };
  };
}
