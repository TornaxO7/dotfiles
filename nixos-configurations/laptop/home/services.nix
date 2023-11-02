{ config, pkgs, lib, ... }:
{
  config = {
    services = {
      blueman-applet.enable = true;
      screen-locker.enable = true;
    };
  };
}
