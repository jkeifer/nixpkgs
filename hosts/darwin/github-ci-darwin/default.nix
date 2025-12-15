{ config, lib, pkgs, ... }:

{
  nixpkgs.hostPlatform = "x86_64-darwin";

  user = {
    enable = true;
    name = "runner";
  };

  # Disable homebrew for CI environment
  homebrew.enable = lib.mkForce false;
}
