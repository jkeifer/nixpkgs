{ config, lib, pkgs, ... }:

# This is a base home-manager configuration that imports all available
# modules and enables a minimal set by default.
#
# To use in a user configuration:
#   homeManager.imports = [ ./home ];
#
# To enable additional modules:
#   homeManager.config.modules.emacs.enable = true;
#   homeManager.config.modules.ssh.enable = true;
#
# To disable base modules:
#   homeManager.config.modules.vim.enable = lib.mkForce false;
#
# To configure child modules (e.g., shells):
#   homeManager.config.modules.shells.zsh.enable = true;   # Enable zsh
#   homeManager.config.modules.shells.bash.enable = false; # Disable bash
#
# To override module configuration directly:
#   homeManager.config.programs.vim.plugins = lib.mkForce [ /* custom list */ ];

{
  imports = [
    ./bat
    ./direnv
    ./emacs
    ./git
    ./github
    ./htop
    ./iterm2
    ./kitty
    ./pkgs
    ./shells/bash.nix
    ./shells/zsh.nix
    ./shells/fish.nix
    ./ssh
    ./tmp
    ./vim
  ];

  programs.home-manager.enable = true;

  # See release notes for state version changes:
  # https://nix-community.github.io/home-manager/release-notes.xhtml
  home.stateVersion = "26.05";

  # Base modules enabled by default
  # Use mkDefault so they can be easily overridden
  modules = {
    bat.enable = lib.mkDefault true;
    direnv.enable = lib.mkDefault true;
    git.enable = lib.mkDefault true;
    vim.enable = lib.mkDefault true;
    shells.bash.enable = lib.mkDefault true;
    tmp.enable = lib.mkDefault true;

    # Package groups enabled by default
    pkgs.core.enable = lib.mkDefault true;
    pkgs.darwin.enable = lib.mkDefault true;  # won't apply to non-darwin hosts

    # Other modules available but disabled by default
    emacs.enable = lib.mkDefault false;
    github.enable = lib.mkDefault false;
    htop.enable = lib.mkDefault false;
    iterm2.enable = lib.mkDefault false;
    kitty.enable = lib.mkDefault false;
    shells.zsh.enable = lib.mkDefault false;
    shells.fish.enable = lib.mkDefault false;
    ssh.enable = lib.mkDefault false;

    # Package groups disabled by default
    pkgs.ai.enable = lib.mkDefault false;
    pkgs.containers.enable = lib.mkDefault false;
    pkgs.fonts.enable = lib.mkDefault false;
    pkgs.networking.enable = lib.mkDefault false;
    pkgs.workstation.enable = lib.mkDefault false;
  };
}
