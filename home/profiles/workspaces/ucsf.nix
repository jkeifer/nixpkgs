{ config, lib, pkgs, directory, ... }:

{
  # UCSF workspace configuration
  # Git configuration and workspace-specific tools

  # Use directory as the git workspace key so condition matches gitdir path
  modules.git.workspaces.${directory} = {
    email = "jarrett.keifer@ucsf.edu";
    name = "Jarrett Keifer";
  };

  # UCSF-specific packages
  home.packages = with pkgs; [
    # Add any UCSF-specific tools here
  ];

  # Create workspace directory
  home.file."${directory}/.keep".text = "";
}
