{ config, pkgs, lib, ... }:
{
  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      dmenu
    ];
  };
}
