{ config, lib, pkgs, ... }:

{
  imports = [
    ./ai.nix
    ./core.nix
    ./containers.nix
    ./darwin.nix
    ./networking.nix
    ./fonts.nix
    ./workstation.nix
  ];
}
