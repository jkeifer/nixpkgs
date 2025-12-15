{ config, lib, pkgs, ... }:

{
  imports = [
    ../../home
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  home = {
    username = "jak";
    homeDirectory = "/home/jak";
  };
}
