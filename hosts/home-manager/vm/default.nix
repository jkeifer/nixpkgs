{ self, config, lib, pkgs, ... }:

{
  imports = [
    "${self}/home"
  ];

  home = {
    username = "jak";
    homeDirectory = "/home/jak";
  };
}
