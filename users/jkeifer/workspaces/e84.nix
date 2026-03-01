{ directory }:

{ config, lib, pkgs, ... }:

{
  modules.git.workspaces.${directory} = {
    email = "jkeifer@element84.com";
    name = "jkeifer";
  };

  home.packages = with pkgs; [
    awscli2
  ];

  home.file."${directory}/.keep".text = "";
}
