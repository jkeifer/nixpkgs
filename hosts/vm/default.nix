{ config, lib, pkgs, ... }:

{
  # System architecture: x86_64-linux (default)
  # This is specified in flake.nix when calling homeManagerConfiguration

  # Import home-manager configuration
  imports = [
    ../../home
  ];

  # Home directory and username
  home = {
    username = "jak";
    homeDirectory = "/home/jak";
  };
}
