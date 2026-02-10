{ config, lib, pkgs, directory, ... }:

{
  # Element84 workspace configuration
  # Git configuration and workspace-specific tools

  # Use directory as the git workspace key so condition matches gitdir path
  modules.git.workspaces.${directory} = {
    email = "jkeifer@element84.com";
    name = "jkeifer";
  };

  # E84-specific packages
  home.packages = with pkgs; [
    # Add any E84-specific tools here
  ];

  # Create workspace directory
  home.file."${directory}/.keep".text = "";
}
