{ config, lib, pkgs, ... }:

{
  # Workstation profile: Full desktop/laptop environment
  # Includes terminal emulator and workspace management

  imports = [
    ./development.nix
    ../kitty
    ../tmp
  ];

  modules = {
    kitty.enable = lib.mkDefault true;
    tmp.enable = lib.mkDefault true;
  };
}
