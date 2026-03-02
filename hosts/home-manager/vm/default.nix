{ self, config, lib, pkgs, ... }:

{
  imports = [
    "{self}/home"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  home = {
    username = "jak";
    homeDirectory = "/home/jak";
  };
}
