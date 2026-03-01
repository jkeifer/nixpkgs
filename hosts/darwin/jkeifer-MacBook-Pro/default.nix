{ self, config, lib, pkgs, ... }:
let
  hostname = "jkeifer-MacBook-Pro";
in {
  imports = [
    ../workstation.nix
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

  home-manager.users.jkeifer = {
    home.packages = with pkgs; [
      awscli2
    ];
  };

  homebrew.casks = [
    "inkscape"
    "orion"
    "qgis"
    "zoom"
  ];

  ids.gids.nixbld = 350;
}
