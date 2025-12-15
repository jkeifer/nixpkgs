{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../common.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  user = {
    enable = true;
    name = "jkeifer";
  };

  users.users.jkeifer = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  networking.hostName = "huijatoo";
}
