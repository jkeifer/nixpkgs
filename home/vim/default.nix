{ pkgs, config, ... }:
let
  extra = builtins.readFile ./extra.vim;
  # TODO: figure out a better way to do this
  #       i.e., as flake inputs
  vim-spell-en-utf8-dictionary = builtins.fetchurl {
    url = "https://ftp.nluug.nl/pub/vim/runtime/spell/en.utf-8.spl";
    sha256 = "fecabdc949b6a39d32c0899fa2545eab25e63f2ed0a33c4ad1511426384d3070";
  };

  vim-spell-en-utf8-suggestions = builtins.fetchurl {
    url = "https://ftp.nluug.nl/pub/vim/runtime/spell/en.utf-8.sug";
    sha256 = "5b6e5e6165582d2fd7a1bfa41fbce8242c72476222c55d17c2aa2ba933c932ec";
  };
in {
  home.file."${config.xdg.configHome}/vim/spell/en.utf-8.spl".source =  vim-spell-en-utf8-dictionary;
  home.file."${config.xdg.configHome}/vim/spell/en.utf-8.sug".source =  vim-spell-en-utf8-suggestions;
  programs.vim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      ${extra}

      let g:coc_node_path = "${pkgs.nodejs}/bin/node"
    '';
    # if needing plugins in the future
    # find supported list: nix-env -f '<nixpkgs>' -qaP -A vimPlugins
    # then add them here
    plugins = with pkgs.vimPlugins; [
      ale
      coc-eslint
      coc-json
      coc-markdownlint
      coc-nvim
      coc-pyright
      coc-rust-analyzer
      coc-tsserver
      coc-yaml
    ];
  };
}
