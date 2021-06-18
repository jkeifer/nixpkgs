{ pkgs, lib, ... }: {
  # GitHub CLI
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.gh.enable
  # Aliases config imported in flake.
  programs.gh = {
    enable = true;
    gitProtocol = "ssh";
  };
}
