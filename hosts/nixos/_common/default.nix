# NixOS workstation configuration
# Shared by all NixOS workstations
{ config, lib, pkgs, ... }:

{
  imports = [
    ../common.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
  ];

  environment.shells = [ pkgs.bashInteractive pkgs.zsh ];

  programs.zsh.enable = true;
}
