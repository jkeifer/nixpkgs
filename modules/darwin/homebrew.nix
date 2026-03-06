{ config, lib, nix-homebrew, pkgs, ... }:

let
  mkIfCaskPresent = cask: lib.mkIf (lib.any (x: x == cask) config.homebrew.casks);
in {
  # Assertion: homebrew.user must be set if homebrew is enabled
  assertions = [
    {
      assertion = !config.homebrew.enable || config.homebrew.user != null;
      message = "homebrew.user must be set when homebrew is enabled";
    }
  ];

  nix-homebrew = lib.mkIf (config.homebrew.user != null) {
    # see https://github.com/zhaofengli/nix-homebrew
    enable = true;

    user = config.homebrew.user;
  };

  homebrew.user = lib.mkIf (config._.primaryUser != null)
    (lib.mkDefault config._.users.${config._.primaryUser}.username);

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
     "${config.users.users.${config.homebrew.user}.home}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
}
