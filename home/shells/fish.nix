{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.shells.fish;
in {
  options.modules.shells.fish = {
    enable = mkEnableOption "fish shell configuration with starship";
  };

  config = mkIf cfg.enable {
    modules.shells.defaultShell = mkOverride 100 pkgs.fish;

    programs.starship = {
      enable = true;
      enableZshIntegration = false;
      settings = {
        # See docs here: https://starship.rs/config/
        directory.fish_style_pwd_dir_length = 1; # turn on fish directory truncation
        time.disabled = false;
      };
    };

    programs.fish = {
      enable = true;
      shellAliases = with pkgs; {
        ":q" = "echo 'hey stupid, this is not vim'";
        cat = "${bat}/bin/bat";
        g = "${gitAndTools.git}/bin/git";
        la = "ll -a";
        ll = "ls -l --time-style long-iso --icons";
        ls = "${eza}/bin/eza";
      };
      shellInit = ''
        set -U fish_term24bit 1
      '';
      interactiveShellInit = ''
        set -g fish_greeting ""
      '';
    };
  };
}
