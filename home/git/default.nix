{ pkgs, lib, ... }: {
  imports = [ ./gh.nix ];

  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.git.enable
  # Aliases config imported in flake.
  programs.git = {
    enable = true;

    userEmail = "jkeifer0@gmail.com";
    userName = "Jarrett Keifer";

    extraConfig = {
      diff.colorMoved = "default";
      pull.rebase = true;
      push.default = "simple";
    };

    ignores = [
      ".DS_Store"
      "_build/"
      "shell.nix"
      ".direnv/"
      ".envrc"
      "*.swp"
    ];

    includes = [
      {
        condition = "gitdir:~/bigleaf/";
        contents = {
          user.name = "jarrettk";
          user.email = "jarrettk@bigleaf.net";
        };
      }
      {
        condition = "gitdir:~/e84/";
        contents = {
          user.name = "jkeifer";
          user.email = "jkeifer@element84.com";
        };
      }
      {
        condition = "gitdir:~/csar/";
        contents = {
          user.name = "Jarrett Keifer";
          user.email = "jkeifer@pdx.edu";
        };
      }
    ];

    # Enhanced diffs
    delta.enable = true;
  };
}
