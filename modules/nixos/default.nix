{ inputs, config, lib, pkgs, spacemacs, zi, ... }: {
  imports = [
    # user settings
    ../user.nix

    # Other nixos configuration
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment = {
    systemPackages = with pkgs; [
      bashInteractive
      coreutils
      curl
      git
      python3
      wget
      vim
      zsh
    ];

    shells = [ pkgs.bashInteractive pkgs.zsh ];
  };

  # Enable zsh since it's the default shell for users
  programs.zsh.enable = true;
}
