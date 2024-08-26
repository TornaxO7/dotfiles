{ config, inputs, pkgs, ... }:
{
  config = {
    programs.rio = {
      enable = true;
      package = inputs.rio.packages.${pkgs.system}.default;
    };

    xdg.configFile.rio = {
      enable = config.programs.rio.enable;
      recursive = true;
      source = ./config-files;
      target = "rio";
    };
  };
}
