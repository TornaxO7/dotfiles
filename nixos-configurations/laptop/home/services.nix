{ config, pkgs, lib, ... }:
{
  config = {
    services.blueman-applet.enable = true;
  };
}
