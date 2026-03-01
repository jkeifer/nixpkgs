{ config, lib, nix-homebrew, pkgs, ... }:

let
  mkIfCaskPresent = cask: lib.mkIf (lib.any (x: x == cask) config.homebrew.casks);
in {
  # Assertion: homebrewUser must be set if homebrew is enabled
  assertions = [
    {
      assertion = !config.homebrew.enable || config.darwin.homebrewUser != null;
      message = "darwin.homebrewUser must be set when homebrew is enabled";
    }
  ];

  nix-homebrew = lib.mkIf (config.darwin.homebrewUser != null) {
    # see https://github.com/zhaofengli/nix-homebrew
    enable = true;

    user = config.darwin.homebrewUser;
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    global = {
      brewfile = true;
    };

    taps = [];

    masApps = {
    };

    casks = [
    ];

    brews = [
      # for cli commands not in nix
      # _should not_ need this
    ];
  };

  # Configuration related to casks
  environment.variables.SSH_AUTH_SOCK = mkIfCaskPresent "secretive"
     "${config.users.users.${config.darwin.homebrewUser}.home}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
}
