{ config, lib, ... }:

let
  mkIfCaskPresent = cask: lib.mkIf (lib.any (x: x == cask) config.homebrew.casks);
in {
  homebrew = {
    enable = true;
    autoUpdate = true;
    cleanup = "zap";

    # TODO: make this dependent on system value
    brewPrefix = "/opt/homebrew/bin";

    global = {
      brewfile = true;
      noLock = true;
    };

    taps = [
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
    ];

    masApps = {
      Amphetamine = 937984704;
      Keynote = 409183694;
      Numbers = 409203825;
      Pages = 409201541;
      #Xcode = 497799835;
    };

    casks = [
      "1password"
      "1password-cli"
      "iterm2"
      "firefox"
      "google-chrome"
      # `home-manager` currently has issues adding them to `~/Applications`
      # Issue: https://github.com/nix-community/home-manager/issues/1341
      "kitty"
      # this one is a mess but it can be helpful:
      # https://github.com/whomwah/qlstephen
      "qlstephen"
      "secretive"
      "slack"
      "wireshark"
      "zoom"
    ];

    brews = [
      # for cli commands not in nix
    ];
  };

  # Configuration related to casks
  environment.variables.SSH_AUTH_SOCK = mkIfCaskPresent "secretive"
     "/Users/${config.user.name}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
}
