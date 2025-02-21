{ config, pkgs, lib, ... }: {
  imports = [
    ./direnv
    ./emacs
    ./git
    ./kitty
    ./shells
    ./ssh
    ./tmp
    ./vim
  ];

  programs = {

    home-manager = {
      enable = true;
    };

    # https://rycee.gitlab.io/home-manager/options.html#opt-programs.bat.enable
    bat = {
      enable = true;
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

    packages = with pkgs; [
      # fonts
      nerd-fonts.fira-code

      # utils
      awscli2
      arping
      coreutils-full
      curl
      docker
      eza
      fd
      findutils
      gawk
      gdb
      ghc
      glab
      gron
      gnugrep
      gnused
      gvproxy
      hugo
      jq
      kitty
      kubectl
      mtr
      netcat
      nmap
      nodejs
      qemu
      pandoc
      ripgrep
      rsync
      socat
      stow
      tree
      watch
      wget
      xz
      zi
      zsh

      #comma # run software from without installing it
      #lorri # improve `nix-shell` experience in combination with `direnv`

    ] ++ lib.optionals stdenv.isDarwin [
      colima
      m-cli # useful macOS CLI commands
    ];

    # This value determines the Home Manager release that your configuration is compatible with. This
    # helps avoid breakage when a new Home Manager release introduces backwards incompatible changes.
    #
    # You can update Home Manager without changing this value. See the Home Manager release notes for
    # a list of state version changes in each release.
    stateVersion = "21.05";

    sessionVariables = {
      TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
    };
  };

  targets.darwin.defaults = {
    "com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
  };
}
