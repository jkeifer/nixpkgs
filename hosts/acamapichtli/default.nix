{ config, lib, pkgs, ... }:

{
  # System architecture
  nixpkgs.hostPlatform = "x86_64-darwin";

  # User configuration
  user = {
    enable = true;
    name = "jarrettk";
  };

  # Networking configuration
  networking = {
    computerName = "acamapichtli";
    hostName = "acamapichtli";
    knownNetworkServices = [
      "Wi-Fi"
      "USB 10/100/1000 LAN"
    ];
  };
}
