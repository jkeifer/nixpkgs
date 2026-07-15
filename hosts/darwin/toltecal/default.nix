{ self, config, lib, pkgs, ... }:
{
  imports = [
    ../_common/workstation.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  _.jkeifer.workspaces = [ "dev" "e84" ];

  networking.knownNetworkServices = [
    "Wi-Fi"
    "USB 10/100/1000 LAN"
  ];

  homebrew.casks = [
    "qgis"
    "zoom"
  ];
}
