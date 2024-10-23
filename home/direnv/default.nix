{ ... }: {
  programs.direnv = {
    # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
    enable = true;
    nix-direnv.enable = true;
    stdlib = builtins.readFile ./direnvrc.sh;
  };
}
