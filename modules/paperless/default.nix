{ inputs, config, pkgs, ... }:
{
  services.paperless = {
    enable = true;
  };
}
