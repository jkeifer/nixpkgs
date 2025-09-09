{ config, pkgs, lib, zi, ... }:
let
  functions = builtins.concatStringsSep
    "\n"
    (
      builtins.map
        (f: builtins.readFile (./functions + ("/" + f)))
        (
          builtins.attrNames (
            pkgs.lib.attrsets.filterAttrs
              (k: v: v == "regular" || v == "symlink")
              (builtins.readDir ./functions)
          )
        )
    );
  aliases = {
    ls = "ls -GpA";
    cat = "bat";
    ":q" = "echo 'hey stupid, this is not vim'";

    mac2win = "perl -pe 's/\r\n|\n|\r/\r\n/g'";  # inputfile > outputfile -- to convert \n to \r\n
    win2mac = "perl -pe 's/\r\n|\n|\r/\n/g'";      # inputfile > outputfile -- to convert \r\n to \n

    # Use the following like `airport scan`
    airport = "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport";
  };
in {
  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  xdg.configFile."zi/bin" = {
    source = zi;
    recursive = true;
  };

  programs = {
    bash = {
      enable = true;
      shellAliases = aliases;
    };

    starship = {
      enable = true;
      enableZshIntegration = false;
      settings = {
        # See docs here: https://starship.rs/config/
        directory.fish_style_pwd_dir_length = 1; # turn on fish directory truncation
        time.disabled = false;
      };
    };

    fish = {
      enable = true;
      shellAliases = with pkgs; {
        ":q" = "echo 'hey stupid, this is not vim'";
        cat = "${bat}/bin/bat";
        g = "${gitAndTools.git}/bin/git";
        la = "ll -a";
        ll = "ls -l --time-style long-iso --icons";
        ls = "${eza}/bin/eza";
      };
      shellInit = ''
        set -U fish_term24bit 1
      '';
      interactiveShellInit = ''
        set -g fish_greeting ""
      '';
    };

    fzf = {
      enable = true;
    };

    zsh = {
      enable = true;
      enableCompletion = false;
      dotDir = "${config.xdg.configHome}/zsh";

      history = {
        expireDuplicatesFirst = true;
        extended = true;
        ignorePatterns = [
          "rm *"
          "kill *"
          "pkill *"
        ];
        ignoreSpace = true;
        share = false;
      };

      initContent = ''
        typeset -Ag ZI
        typeset -gx ZI[HOME_DIR]="''${HOME}/.config/zi"
        typeset -gx ZI[BIN_DIR]="''${HOME}/.config/zi/bin"
        source "''${HOME}/.config/zi/bin/zi.zsh"
        ${functions}
        ${builtins.readFile ./config.zsh}
      '';

      shellAliases = aliases;
    };
  };

  xdg.configFile."zsh/p10k.zsh".text = builtins.readFile ./p10k.zsh;
}
