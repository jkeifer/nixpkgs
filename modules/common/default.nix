{ config, lib, pkgs, ... }:

{
  imports = [
    ./nix.nix
    ./users.nix
  ];

  # Common cross-platform system configuration
  # Shared by all Darwin and NixOS systems
}
