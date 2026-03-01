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
      cores = 8;
      max-jobs = 8;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };
}
