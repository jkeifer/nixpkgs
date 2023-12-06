{ config, lib, pkgs, ... }:

let
  mkIfCaskPresent = cask: lib.mkIf (lib.any (x: x == cask) config.homebrew.casks);
  brewBinPrefix = if pkgs.system == "aarch64-darwin" then "/opt/homebrew/bin" else "/usr/local/bin";
in {
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
      Calendar366II = 1265895169;
      #Keynote = 409183694;
      #Numbers = 409203825;
      #Pages = 409201541;
      #Xcode = 497799835;
    };

    casks = [
      "1password"
      "1password-cli"
      #"firefox"
      #"google-chrome"
      # this one is a mess but it can be helpful:
      # https://github.com/whomwah/qlstephen
      "qlstephen"
      "raycast"
      "secretive"
      #"slack"
      #"wireshark"
      #"zoom"
    ];

    brews = [
      # for cli commands not in nix
    ];
  };

  # Configuration related to casks
  environment.variables.SSH_AUTH_SOCK = mkIfCaskPresent "secretive"
     "${config.users.users.username.home}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
}
