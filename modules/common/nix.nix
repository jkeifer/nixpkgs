{ inputs, config, lib, pkgs, ... }:

{
  # Common Nix settings shared across all platforms
  nix = {
    package = pkgs.nixVersions.latest;

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';

    # Use new-style settings options (NixOS 23.05+)
    settings = {
      trusted-users = [ "${config.user.name}" "root" "@admin" "@wheel" ];
      cores = 8;
      max-jobs = 8;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };

    # nixPath removed - not needed for flake-based workflows
    # If needed for legacy commands, set in platform-specific modules
  };
}
