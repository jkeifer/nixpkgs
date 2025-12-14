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
    computerName = "oxomoco";
    hostName = "oxomoco";
    knownNetworkServices = [
      "Wi-Fi"
      "USB 10/100/1000 LAN"
    ];
  };

  # Homebrew configuration specific to this system
  homebrew.masApps = {
    msRDP = 1295203466;
  };

  homebrew.casks = [
    "google-chrome"
    "zoom"
  ];
}
