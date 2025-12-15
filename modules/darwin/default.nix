{ inputs, config, lib, pkgs, spacemacs, zi, ... }: {
  imports = [
    # Minimal config of Nix related options and shells
    ./bootstrap.nix

    # user settings
    ../user.nix

    # Other nix-darwin configuration
    ./homebrew.nix
    ./defaults.nix
  ];

  # For more on the directives provided by nix-darwin:
  # https://daiderd.com/nix-darwin/manual/index.html
}
