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

  # Enable workspaces for this host
  homeProfile.workspaces = {
    e84 = {};      # Uses default directory "e84"
    bigleaf = {};  # Uses default directory "bigleaf"
    csar = {};     # Uses default directory "csar"
    ucsf = {};     # Uses default directory "ucsf"
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
