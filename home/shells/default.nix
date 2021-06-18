{  pkgs, ... }:
let
  functions = builtins.readFile ./functions.sh;
  zshExtra = builtins.readFile ./extra.zsh;
  aliases = {
    ls = "ls -GpA";
    cat = "bat";

    mac2win = "perl -pe 's/\r\n|\n|\r/\r\n/g'";  # inputfile > outputfile -- to convert \n to \r\n
    win2mac = "perl -pe 's/\r\n|\n|\r/\n/g'";      # inputfile > outputfile -- to convert \r\n to \n

    # Use the following like `airport scan`
    airport = "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport";
  };
in {
  programs = {
    bash = {
      enable = true;
      shellAliases = aliases;
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;

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
      initExtra = ''
        ${functions}
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        ${zshExtra}
      '';
      shellAliases = aliases;
    };
  };

  home.file.".p10k.zsh".source = ./.p10k.zsh;

  #environment.pathsToLink = [ "/share/zsh" ];
}
