{ config, lib, pkgs, ... }:

{
  # System architecture
  nixpkgs.hostPlatform = "x86_64-darwin";

  # User configuration
  user = {
    enable = true;
    name = "runner";
  };

  # Disable homebrew for CI environment
  homebrew.enable = lib.mkForce false;
}
