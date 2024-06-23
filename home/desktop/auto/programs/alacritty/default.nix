{ config, ... }:
{
  config = {
    programs.alacritty = { };

    xdg.configFile.alacritty = {
      enable = config.programs.alacritty.enable;
      recursive = true;
      source = ./config-files;
      target = "alacritty";
    };
  };
}
