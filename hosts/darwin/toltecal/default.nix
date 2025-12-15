{ config, lib, pkgs, ... }:

{
  imports = [
    ../common.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  user = {
    enable = true;
    name = "jkeifer";
  };

  networking = {
    computerName = "toltecal";
    hostName = "toltecal";
    knownNetworkServices = [
      "Wi-Fi"
      "USB 10/100/1000 LAN"
    ];
  };

  homebrew.casks = [
    "google-chrome"
    "qgis"
    "slack"
    "zoom"
  ];
}
