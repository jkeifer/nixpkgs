# Darwin workstation configuration
# Shared by all Darwin workstations (but not CI systems)
{ self, config, lib, pkgs, ... }:

{
  imports = [
    "${self}/hosts/common"
  ];

  # Darwin-specific packages
  environment.systemPackages = with pkgs; [
  ];

  environment.shells = [ pkgs.bashInteractive pkgs.zsh ];
  environment.pathsToLink = [ "/share/zsh" ];

  # nix-index for command-not-found functionality
  programs.nix-index.enable = true;
}
