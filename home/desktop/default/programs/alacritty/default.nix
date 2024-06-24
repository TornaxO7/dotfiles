{ config, ... }:
{
  config = {
    programs.alacritty.enable = true;

    xdg.configFile.alacritty = {
      enable = config.programs.alacritty.enable;
      recursive = true;
      source = ./config-files;
      target = "alacritty";
    };
  };
}
