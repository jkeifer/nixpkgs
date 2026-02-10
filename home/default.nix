{ config, pkgs, lib, ... }: {
  # User-specific home-manager configuration
  #
  # NOTE: Profiles and modules are imported at the HOST level.
  # This file contains only user-specific data and preferences.
  #
  # See hosts/*/default.nix for profile imports:
  #   - Darwin workstations: workstation.nix + darwin.nix
  #   - NixOS workstations: workstation.nix
  #   - CI systems: base.nix

  # User-specific git configuration
  # Workspace-specific git configs are now managed by workspace profiles
  # selected at the host level via homeProfile.workspaces
  modules.git = {
    user = {
      email = "jkeifer0@gmail.com";
      name = "Jarrett Keifer";
    };
  };

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
      claude-code
      coreutils-full
      curl
      docker
      eza
      fd
      findutils
      gawk
      gdb
      gemini-cli
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
      qrencode
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
}
