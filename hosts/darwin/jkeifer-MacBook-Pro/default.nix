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
    computerName = "jkeifer-MacBook-Pro";
    hostName = "jkeifer-MacBook-Pro";
    knownNetworkServices = [
      "Wi-Fi"
      "USB 10/100/1000 LAN"
    ];
  };

  homebrew.casks = [
    "google-chrome"
    "inkscape"
    "orion"
    "qgis"
    "slack"
    "zoom"
  ];

  ids.gids.nixbld = 350;
}
