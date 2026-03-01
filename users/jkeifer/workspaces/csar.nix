{ directory }:

{ config, lib, pkgs, ... }:

{
  modules.git.workspaces.${directory} = {
    email = "jkeifer@pdx.edu";
    name = "Jarrett Keifer";
  };

  home.packages = with pkgs; [
  ];

  home.file."${directory}/.keep".text = "";
}
