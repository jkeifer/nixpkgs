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
    computerName = "oxomoco";
    hostName = "oxomoco";
    knownNetworkServices = [
      "Wi-Fi"
      "USB 10/100/1000 LAN"
    ];
  };

  homebrew.masApps = {
    msRDP = 1295203466;
  };

  homebrew.casks = [
    "google-chrome"
    "zoom"
  ];
}
