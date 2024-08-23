{ pkgs, ... }:
{
  imports = [
    ./i3.nix
    ./minecraft.nix

    ../../../home/client.nix
  ];

  home = {
    packages = with pkgs; [
      eww
      rpi-imager
      lact
    ];

    pointerCursor.size = 20;
  };

  services.picom = {
    enable = true;
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
