{ config, lib, ... }:
{
  xdg.configFile = {
    nvim = {
      enable = true;
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink "../../config/nvim";
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
      source = config.lib.file.mkOutOfStoreSymlink "../../config/vifm";
      target = "vifm";
    };

    rio = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink "../../config/rio";
      target = "rio";
    };
  };
}
