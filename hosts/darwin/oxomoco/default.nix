{ self, config, lib, pkgs, ... }:
let
  hostname = "oxomoco";
in {
  imports = [
    ../_common/workstation.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  _.jkeifer.workspaces = [ "dev" "csar" ];

  networking = {
    computerName = hostname;
    hostName = hostname;
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
