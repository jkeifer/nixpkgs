{ config, lib, pkgs, ... }:

{
  imports = [
    ../common.nix
  ];

  nixpkgs.hostPlatform = "x86_64-darwin";

  user = {
    enable = true;
    name = "jarrettk";
  };

  networking = {
    computerName = "acamapichtli";
    hostName = "acamapichtli";
    knownNetworkServices = [
      "Wi-Fi"
      "USB 10/100/1000 LAN"
    ];
  };
}
