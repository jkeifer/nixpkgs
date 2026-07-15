{ config, pkgs, lib, ... }:

with lib;
let
  aliases = {
    ls = "ls -GpA";
    cat = "bat";
    ":q" = "echo 'hey stupid, this is not vim'";

    mac2win = "perl -pe 's/\r\n|\n|\r/\r\n/g'";  # inputfile > outputfile -- to convert \n to \r\n
    win2mac = "perl -pe 's/\r\n|\n|\r/\n/g'";      # inputfile > outputfile -- to convert \r\n to \n
  };
in {
  # Shared shell configuration imported by bash and zsh modules

  options.modules.shells.defaultShell = mkOption {
    type = types.package;
    default = pkgs.bash;
    description = "Default shell package set by enabled shell modules";
  };

  config = {
    _module.args = { shellAliases = aliases; };

    home.sessionPath = [
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
    ];

    programs.fzf = {
      enable = true;
    };
  };
}
