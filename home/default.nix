{ config, pkgs, lib, ... }: {
  imports = [
    ./emacs
    ./git
    ./iterm2
    ./kitty
    ./shells
    ./ssh
    ./tmp
    ./vim
  ];

  programs = {

    home-manager = {
      enable = true;
      path = "${config.home.homeDirectory}/.nixpkgs/home";
    };

    # https://rycee.gitlab.io/home-manager/options.html#opt-programs.bat.enable
    bat = {
      enable = true;
    };

    # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
    htop = {
      enable = true;
      settings.show_program_path = true;
    };

  };

  # allows installing font packages below
  fonts.fontconfig.enable = true;

  home = {

    sessionVariables = {
      EDITOR = "vim";
    };

    packages = with pkgs; [
      # fonts
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })

      # utils
      awscli2
      arping
      coreutils-full
      curl
      exa
      fd
      findutils
      gawk
      ghc
      glab
      gnugrep
      gnused
      hugo
      jq
      mtr
      netcat
      nmap
      qemu
      pandoc
      ripgrep
      rsync
      socat
      stow
      tree
      watch
      wget
      zsh
      zsh-powerlevel10k

      #comma # run software from without installing it
      #lorri # improve `nix-shell` experience in combination with `direnv`

    ] ++ lib.optionals stdenv.isDarwin [
      m-cli # useful macOS CLI commands
    ];

    # This value determines the Home Manager release that your configuration is compatible with. This
    # helps avoid breakage when a new Home Manager release introduces backwards incompatible changes.
    #
    # You can update Home Manager without changing this value. See the Home Manager release notes for
    # a list of state version changes in each release.
    stateVersion = "21.05";

  };

  targets.darwin.defaults = {
    "com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
  };
}
