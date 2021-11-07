{ pkgs, zinit, ... }:
let
  functions = builtins.readFile ./functions.sh;
  aliases = {
    ls = "ls -GpA";
    cat = "bat";

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

  home.file.".zinit/bin" = {
    source = zinit;
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
        ls = "${exa}/bin/exa";
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
      dotDir = ".config/zsh";

      # disable completion as we handle it in init
      completionInit = [ ];

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
      initExtraBeforeCompInit = ''
        source ~/.zinit/bin/zinit.zsh
      '';
      initExtra = ''
        ${functions}
        ${builtins.readFile ./config.zsh}
      '';
      shellAliases = aliases;
    };
  };

  xdg.configFile."zsh/p10k.zsh".text = builtins.readFile ./p10k.zsh;
}
