# Cross-platform workstation configuration
# Shared by all Darwin and NixOS workstations
{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bashInteractive
    coreutils
    curl
    git
    python3
    wget
    zsh
  ];
}
