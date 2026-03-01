{ self, config, lib, pkgs, ... }:
let
  hostname = "toltecal";
in {
  imports = [
    ../common.nix
    "${self}/users/jkeifer"
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  jkeifer.workspaces = [ "dev" "e84" ];

  networking = {
    computerName = hostname;
    hostName = hostname;
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
