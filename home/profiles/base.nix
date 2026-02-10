{ config, lib, pkgs, ... }:

{
  # Base profile: Minimal essentials for any environment
  # Includes version control, direnv, and basic editor

  imports = [
    ../direnv
    ../git
    ../vim
  ];

  modules = {
    direnv.enable = lib.mkDefault true;
    git.enable = lib.mkDefault true;
    vim.enable = lib.mkDefault true;
  };
}
