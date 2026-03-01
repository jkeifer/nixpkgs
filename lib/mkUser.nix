{ username
, fullName
, shell ? null
, gitEmail ? null
, gitName ? null
, trustedForNix ? false
}:

{ config, lib, pkgs, ... }:

{
  users.users.${username} = {
    description = fullName;
    home = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
    shell = if shell != null
            then shell
            else config.home-manager.users.${username}.modules.shells.defaultShell;
    trustedForNix = trustedForNix;
  } // lib.optionalAttrs (!pkgs.stdenv.isDarwin) {
    # NixOS-specific settings
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # Home-manager configuration for this user
  # User modules should extend this with their own home config
  home-manager.users.${username} = { self, ... }: {
    imports = [
      "${self}/home"
    ];

    modules.git = lib.optionalAttrs (gitEmail != null && gitName != null) {
      user = {
        email = gitEmail;
        name = gitName;
      };
    };
  };
}
