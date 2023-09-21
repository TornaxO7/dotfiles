{ inputs, config, pkgs, ... }:
{
  services.paperless = {
    enable = true;
    dataDir = "/main/paperless";
    user = "tornax";
  };
}
