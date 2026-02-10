{ config, lib, pkgs, ... }:

{
  # Development profile: Full development environment
  # Includes shells, editors, and SSH for remote development

  imports = [
    ./base.nix
    ../emacs
    ../shells
    ../ssh
  ];

  modules = {
    shells.enable = lib.mkDefault true;
    emacs.enable = lib.mkDefault true;
    ssh.enable = lib.mkDefault true;
  };
}
