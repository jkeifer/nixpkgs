{ self, config, lib, pkgs, ... }:

{
  imports = [
    ./default.nix
    "${self}/users/jkeifer"
  ];

  _.primaryUser = "jkeifer";

  _.users.jkeifer.homeManager.config = {
    modules = {
      github.enable = true;
      htop.enable = true;
      kitty.enable = true;
      vim.enable = true;
      shells.zsh.enable = true;

      ssh = {
        enable = true;
      };

      pkgs.ai.enable = true;
      pkgs.containers.enable = true;
      pkgs.fonts.enable = true;
      pkgs.networking.enable = true;
      pkgs.workstation.enable = true;
    };
  };

  homebrew = {
    casks = [
      "1password"
      "1password-cli"
      "google-chrome"
      "itsycal"
      # this one is a mess but it can be helpful:
      # https://github.com/whomwah/qlstephen
      "qlstephen"
      "raycast"
      "secretive"
      "slack"
    ];

    masApps = {
      Amphetamine = 937984704;
      #Calendar366II = 1265895169;
      #Keynote = 409183694;
      #Numbers = 409203825;
      #Pages = 409201541;
      #Xcode = 497799835;
    };
  };

  ids.gids.nixbld = 350;
}
