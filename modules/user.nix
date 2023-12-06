{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user;
in {
  options.user = {
    enable = mkEnableOption "custom user";
    name = mkOption {
      type = types.str;
    };
    description = mkOption {
      type = types.str;
      default = "Jarrett Keifer";
    };
    shell = mkOption {
      type = types.str;
      default = "zsh";
    };
  };


  config = mkIf cfg.enable {
    users.users.${cfg.name} = {
      #group = cfg.name;
      #isNormalUser = true;
      #extraGroups = [ "wheel" ];
      description = cfg.description;
      home = "${ if pkgs.stdenvNoCC.isDarwin then "/Users" else "/home" }/${cfg.name}";
      shell = pkgs.${cfg.shell};
    };
  };
}
