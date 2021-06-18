{ inputs, config, lib, pkgs, ... }: {
  imports = [
    # Minimal config of Nix related options and shells
    ./bootstrap.nix

    # user settings
    ../user.nix

    # Other nix-darwin configuration
    ./homebrew.nix
    ./defaults.nix

    ../home-manager.nix
  ];

  # For more on the directives provided by nix-darwin:
  # https://daiderd.com/nix-darwin/manual/index.html

  networking.dns = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  environment = {

    # `home-manager` currently has issues adding them to `~/Applications`
    # Issue: https://github.com/nix-community/home-manager/issues/1341
    systemPackages = with pkgs; [
      bashInteractive
      coreutils
      curl
      git
      kitty
      python3
      wget
      vim
      zsh
    ];

    shells = [ pkgs.bashInteractive pkgs.zsh ];

    # https://github.com/nix-community/home-manager/issues/423
    variables = {
      TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
    };
  };

  programs.nix-index.enable = true;

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # Lorri daemon
  # https://github.com/target/lorri
  # Used in conjuction with Direnv which is installed in `../home/default.nix`.
  #services.lorri.enable = true;
}
