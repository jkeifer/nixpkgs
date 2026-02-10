{ config, lib, pkgs, ... }:

{
  nixpkgs.hostPlatform = "x86_64-darwin";

  user = {
    enable = true;
    name = "runner";
  };

  # Use minimal profile for CI
  homeProfile.profile = "base";

  # Disable homebrew for CI environment
  homebrew.enable = lib.mkForce false;
}
