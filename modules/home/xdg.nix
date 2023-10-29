{ config, lib, ... }:
{
  xdg.configFile = {
    nvim = {
      enable = true;
      recursive = true;
      source = ../../config/nvim;
      target = "nvim";
    };

    zellij = {
      enable = true;
      recursive = true;
      source = ../../config/zellij;
      target = "zellij";
    };

    vifm = {
      enable = true;
      source = ../../config/vifm;
      target = "vifm";
    };

    rio = {
      enable = true;
      source = ../../config/rio;
      target = "rio";
    };
  };
}
