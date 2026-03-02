{ self, config, lib, pkgs, ... }:
let
  hostname = "toltecal";
in {
  imports = [
    ../_common/workstation.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  _.jkeifer.workspaces = [ "dev" "e84" ];

  networking = {
    computerName = hostname;
    hostName = hostname;
    knownNetworkServices = [
      "Wi-Fi"
      "USB 10/100/1000 LAN"
    ];
  };

  homebrew.casks = [
    "qgis"
    "zoom"
  ];
}
