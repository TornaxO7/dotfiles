{ config, ... }:
{
  config = {
    programs.zellij.enable = true;

    xdg.configFile.zellij = {
      enable = config.programs.zellij.enable;
      recursive = true;
      source = ./config-files;
      target = "zellij";
    };
  };
}
