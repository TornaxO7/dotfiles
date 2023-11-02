{ config, pkgs, lib, ... }:
{
  config = {
    services = {
      blueman-applet.enable = true;
      screen-locker = {
        enable = true;
        lockCmd = "i3lock -i /main/Images/FSN/ArcherRinBlue.png -e";
      };
    };
  };
}
