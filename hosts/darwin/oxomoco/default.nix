{ self, config, lib, pkgs, ... }:
let
  hostname = "oxomoco";
in {
  imports = [
    ../_common/workstation.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  _.jkeifer.workspaces = [ "dev" "csar" ];

  # This host runs Lix instead of CppNix, overriding the shared
  # `lib.mkDefault pkgs.nixVersions.latest` default in modules/common/nix.nix.
  nix.package = pkgs.lix;

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
