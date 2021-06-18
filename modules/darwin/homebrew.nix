{ config, lib, ... }:

let
  mkIfCaskPresent = cask: lib.mkIf (lib.any (x: x == cask) config.homebrew.casks);
in {
  homebrew.enable = true;
  homebrew.autoUpdate = true;
  homebrew.cleanup = "zap";
  homebrew.global.brewfile = true;
  homebrew.global.noLock = true;

  homebrew.taps = [
    "homebrew/cask"
    "homebrew/cask-drivers"
    "homebrew/cask-fonts"
    "homebrew/cask-versions"
    "homebrew/core"
    "homebrew/services"
  ];

  homebrew.masApps = {
    Amphetamine = 937984704;
    Keynote = 409183694;
    Numbers = 409203825;
    Pages = 409201541;
    #Xcode = 497799835;
  };

  homebrew.casks = [
    "1password"
    "1password-cli"
    "iterm2"
    "firefox"
    "google-chrome"
    "secretive"
    "slack"
    "wireshark"
  ];

  # Configuration related to casks
  environment.variables.SSH_AUTH_SOCK = mkIfCaskPresent "secretive"
     "/Users/${config.user.name}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";

  homebrew.brews = [
    # for cli commands not in nix
  ];
}
