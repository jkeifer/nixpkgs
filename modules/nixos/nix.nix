{ config, lib, pkgs, ... }:

{
  # NixOS-specific Nix settings

  # Make the Nix store read-only
  fileSystems."/nix/store" = {
    device = "/nix/store";
    options = [ "ro" "bind" ];
    fsType = "none";
  };
}
