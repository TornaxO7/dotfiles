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
      recursive = true;
      target = "vifm";
    };

    rio = {
      enable = true;
      recursive = true;
      source = ../../config/rio;
      target = "rio";
    };

    nushell = {
      enable = true;
      recursive = true;
      source = ../../config/nushell;
      target = "nushell";
    };
  };
}
