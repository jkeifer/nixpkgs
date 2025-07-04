{ config, lib, nix-homebrew, pkgs, ... }:

let
  mkIfCaskPresent = cask: lib.mkIf (lib.any (x: x == cask) config.homebrew.casks);
  brewBinPrefix = if pkgs.system == "aarch64-darwin" then "/opt/homebrew/bin" else "/usr/local/bin";
in {
  nix-homebrew = {
    # see https://github.com/zhaofengli/nix-homebrew
    enable = true;

    user = "${config.user.name}";
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    brewPrefix = brewBinPrefix;

    global = {
      brewfile = true;
    };

    taps = [];

    masApps = {
      Amphetamine = 937984704;
      #Calendar366II = 1265895169;
      #Keynote = 409183694;
      #Numbers = 409203825;
      #Pages = 409201541;
      #Xcode = 497799835;
    };

    casks = [
      "1password"
      "1password-cli"
      # this one is a mess but it can be helpful:
      # https://github.com/whomwah/qlstephen
      "itsycal"
      "qlstephen"
      "raycast"
      "secretive"
    ];

    brews = [
      # for cli commands not in nix
      # _should not_ need this
    ];
  };

  # Configuration related to casks
  environment.variables.SSH_AUTH_SOCK = mkIfCaskPresent "secretive"
     "${config.users.users.username.home}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
}
