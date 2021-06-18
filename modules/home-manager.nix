{ inputs, config, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
  };
  home-manager.users.${config.user.name} = import ../home;
}
