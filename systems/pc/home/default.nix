{ pkgs, ... }:
{
  imports = [
    ./minecraft.nix

    ../../../home/client.nix
  ];

  home = {
    packages = with pkgs; [
      android-studio
      eww
      lact
      obs-studio
      podman-compose
      poppler_utils
      rpi-imager
      steamcmd
      xsane
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
