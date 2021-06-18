{ ... }:
let
  tmpdir = "~/tmp/ssh";
in {
  programs = {
    ssh = {
      enable = true;

      controlMaster  = "auto";
      controlPath    = "${tmpdir}/ssh-%u-%r@%h:%p";
      controlPersist = "600";

      hashKnownHosts = true;

      # interesting config examples:
      # https://github.com/jwiegley/nix-config/blob/master/config/home.nix
      matchBlocks = {
        github = {
          host = "*github.com";
          identityFile = "~/.ssh/id_github";
          identitiesOnly = true;
        };

        keychain = {
          host = "*";
          extraOptions = {
            UseKeychain    = "yes";
            AddKeysToAgent = "yes";
            IgnoreUnknown  = "UseKeychain";
          };
        };
      };
    };
  };
}
