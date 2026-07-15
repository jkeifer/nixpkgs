{ inputs, config, lib, pkgs, ... }:

with lib;
{
  imports = [
    ./nix.nix
    ./homebrew.nix
    ./defaults.nix
  ];

  config = {
    environment.shells = with pkgs; [
      bashInteractive
      zsh
    ];

    programs.zsh.enable = true;

    # Used for backwards compatibility, please read the changelog before changing.
    system.stateVersion = 4;
  };

  # For more on the directives provided by nix-darwin:
  # https://daiderd.com/nix-darwin/manual/index.html
}
