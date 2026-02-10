{ config, lib, pkgs, directory, ... }:

{
  # Bigleaf workspace configuration
  # Git configuration and workspace-specific tools

  # Use directory as the git workspace key so condition matches gitdir path
  modules.git.workspaces.${directory} = {
    email = "jarrettk@bigleaf.net";
    name = "jarrettk";
  };

  # Bigleaf-specific packages
  home.packages = with pkgs; [
    # Add any Bigleaf-specific tools here
  ];

  # Create workspace directory
  home.file."${directory}/.keep".text = "";
}
