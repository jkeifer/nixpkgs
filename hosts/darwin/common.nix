# Darwin workstation configuration
# Shared by all Darwin workstations (but not CI systems)
{ config, lib, pkgs, ... }:

{
  imports = [
    ../common.nix
  ];

  # Darwin-specific packages
  environment.systemPackages = with pkgs; [
  ];

  environment.shells = [ pkgs.bashInteractive pkgs.zsh ];
  environment.pathsToLink = [ "/share/zsh" ];

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # nix-index for command-not-found functionality
  programs.nix-index.enable = true;
}
