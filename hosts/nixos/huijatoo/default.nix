{ self, config, lib, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../_common
    "${self}/users/jkeifer"
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
}
