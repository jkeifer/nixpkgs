{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix
  ];

  # System architecture
  nixpkgs.hostPlatform = "aarch64-linux";

  # User configuration
  user = {
    enable = true;
    name = "jkeifer";
  };

  # NixOS-specific user settings
  users.users.jkeifer = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # Networking configuration
  networking.hostName = "huijatoo";
}
