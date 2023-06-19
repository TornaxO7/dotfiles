{ config, lib }: 
{
  configFile = {
    zellij = {
      enable = true;
      recursive = true;
      source = ../../config/zellij;
      target = "zellij";
    };

    vifm = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink /home/tornax/dotfiles/config/vifm;
      target = "vifm";
    };
  };
}
