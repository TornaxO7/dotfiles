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
      recursive = true;
      source = ../../config/vifm;
      target = "vifm";
    };
  };
}
