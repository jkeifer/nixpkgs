{ inputs, config, lib, pkgs, ... }: {
  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    trustedUsers = [ "${config.user.name}" "root" "@admin" "@wheel" ];
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    buildCores = 8;
    maxJobs = 8;
    readOnlyStore = true;
    nixPath = { nixpkgs = "$HOME/.nixpkgs/nixpkgs.nix"; };
    #nixPath = [
    #  "nixpkgs=/etc/${config.environment.etc.nixpkgs.target}"
    #  "home-manager=/etc/${config.environment.etc.home-manager.target}"
    #];
  };
}
