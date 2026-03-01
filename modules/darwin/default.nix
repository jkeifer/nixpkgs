{ inputs, config, lib, pkgs, spacemacs, zi, ... }:

with lib;
{
  imports = [
    ./nix.nix
    ./homebrew.nix
    ./defaults.nix
  ];

  options.darwin = {
    homebrewUser = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Username of the user managing Homebrew (required if homebrew is enabled)";
      example = "jkeifer";
    };
  };

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
