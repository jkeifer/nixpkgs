{ config, lib, pkgs, ... }:

{
  # System architecture
  nixpkgs.hostPlatform = "aarch64-darwin";

  # User configuration
  user = {
    enable = true;
    name = "jkeifer";
  };

  # Networking configuration
  networking = {
    computerName = "toltecal";
    hostName = "toltecal";
    knownNetworkServices = [
      "Wi-Fi"
      "USB 10/100/1000 LAN"
    ];
  };

  # Homebrew casks specific to this system
  homebrew.casks = [
    "google-chrome"
    "qgis"
    "slack"
    "zoom"
  ];
}
