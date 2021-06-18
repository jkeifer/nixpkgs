{ inputs, config, lib, pkgs, ... }: {
  nixpkgs = {
    config = {
      allowUnsupportedSystem = true;
      allowUnfree = true;
      allowBroken = false;
    };
    overlays = [ ];
  };
}
