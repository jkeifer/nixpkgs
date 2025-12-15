{ inputs, config, lib, pkgs, spacemacs, zi, ... }: {
  imports = [
    # user settings
    ../user.nix

    # Other nixos configuration
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
