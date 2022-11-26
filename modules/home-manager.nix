{ config, spacemacs, zi, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit spacemacs zi; };
  };
  # TODO: consider if this should be moved into the import
  # so other things like environment and whatnot can be used
  # in home config
  home-manager.users.${config.user.name} = import ../home;
}
