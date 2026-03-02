# NixOS workstation configuration
# Shared by all NixOS workstations
{ self, config, lib, pkgs, ... }:

{
  imports = [
    "${self}/hosts/common"
  ];

  environment.systemPackages = with pkgs; [
    vim
  ];

  environment.shells = [ pkgs.bashInteractive pkgs.zsh ];

  programs.zsh.enable = true;
}
