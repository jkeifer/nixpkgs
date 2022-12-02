{ pkgs, ... }:
let
  extra = builtins.readFile ./extra.vim;
in {
  programs.vim = {
    enable = true;
    extraConfig = ''
      ${extra}
    '';
    # if needing plugins in the future
    # find supported list: nix-env -f '<nixpkgs>' -qaP -A vimPlugins
    # then add them here
    plugins = with pkgs.vimPlugins; [
    ];
  };
}
