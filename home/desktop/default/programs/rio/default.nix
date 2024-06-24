{ config, inputs, system, ... }:
{
  config = {
    programs.rio = {
      enable = false;
      package = inputs.rio.packages.${system}.default;
    };

    xdg.configFile.rio = {
      enable = config.programs.rio.enable;
      recursive = true;
      source = ./config-files;
      target = "rio";
    };
  };
}
