{ config, ... }:
{
  xdg.configFile = {
    nvim = {
      enable = true;
      recursive = true;
      source = ../config/nvim;
      target = "nvim";
    };

    zellij = {
      enable = true;
      recursive = true;
      source = ../config/zellij;
      target = "zellij";
    };

    rio = {
      enable = true;
      recursive = true;
      source = ../config/rio;
      target = "rio";
    };

    # nushell_plugins = {
    #   enable = config.programs.nushell.enable;
    #   recursive = true;
    #   source = ../config/nushell/plugins;
    #   target = "nushell/plugins";
    # };

    vifm = {
      enable = true;
      # cache has to writeable so we have to do it that way
      source = config.lib.file.mkOutOfStoreSymlink /home/tornax/dotfiles/config/vifm;
      target = "vifm";
    };

    nushell_scripts = {
      enable = config.programs.nushell.enable;
      recursive = true;
      source = ../config/nushell/scripts;
      target = "nushell/scripts";
    };

    yazi_config = {
      enable = config.programs.yazi.enable;
      recursive = true;
      source = config.lib.file.mkOutOfStoreSymlink /home/tornax/dotfiles/config/yazi;
      target = "yazi";
    };
  };
}
