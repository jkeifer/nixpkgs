{ self, config, lib, pkgs, ... }:
let
  hostname = "huijatoo";
in {
  imports = [
    ./hardware.nix
    ../common.nix
    "${self}/users/jkeifer"
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  networking.hostName = hostname;
}
