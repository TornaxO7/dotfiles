{ config, pkgs, lib, ... }:
{
  imports = [
    ./i3.nix
  ];

  home = {
    packages = with pkgs; [
      eww
      rpi-imager
    ];
    pointerCursor.size = 20;
  };

  services.picom = {
    enable = true;
    # activeOpacity = 0.75;
    backend = "glx";
    vSync = true;
  };

  xdg.configFile = {
    eww = {
      enable = true;
      recursive = true;
      source = ../config/eww;
      target = "eww";
    };
  };
}
