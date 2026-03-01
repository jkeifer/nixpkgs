{ self, config, lib, pkgs, spacemacs, zi, ... }:

{
  # Global home-manager configuration
  # Individual user configurations are handled by user modules (e.g., users/jkeifer.nix)

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit self spacemacs zi; };
  };
}
