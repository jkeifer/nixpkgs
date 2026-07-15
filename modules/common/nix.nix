{ inputs, config, lib, pkgs, ... }:
{
  # Common Nix settings shared across all platforms
  nix = {
    enable = true;
    package = lib.mkDefault pkgs.nixVersions.latest;

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';

    settings = {
      # Binary cache configuration
      substituters = [
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];

      trusted-users = (lib.attrNames (lib.filterAttrs (name: user: user.trustedForNix or false) config.users.users)) ++ [ "@admin" "@wheel" ];

      # size parallelism to the machine rather than assuming 8 cores
      cores = 0;
      max-jobs = "auto";
    };

    # Pin the registry's nixpkgs to the flake input so ad-hoc commands
    # (nix shell nixpkgs#foo, nix run nixpkgs#bar) use the exact revision
    # the system was built from instead of whatever the channel resolves to
    registry.nixpkgs.flake =
      if pkgs.stdenv.isDarwin then inputs.nixpkgs-unstable else inputs.nixos-unstable;

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };
}
