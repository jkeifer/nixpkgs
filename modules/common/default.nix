{ config, lib, pkgs, ... }:

{
  imports = [
    ./nix.nix
    ./user.nix
  ];

  # Common cross-platform system configuration
  # Shared by all Darwin and NixOS systems
}
