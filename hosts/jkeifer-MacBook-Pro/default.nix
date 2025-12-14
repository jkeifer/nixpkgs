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
    computerName = "jkeifer-MacBook-Pro";
    hostName = "jkeifer-MacBook-Pro";
    knownNetworkServices = [
      "Wi-Fi"
      "USB 10/100/1000 LAN"
    ];
  };

  # Homebrew casks specific to this system
  homebrew.casks = [
    "google-chrome"
    "inkscape"
    "orion"
    "qgis"
    "slack"
    "zoom"
  ];

  # Custom nixbld group ID for this system
  ids.gids.nixbld = 350;
}
