{ pkgs, ... }:
{
  imports = [
    ./minecraft.nix

    ../../../home/client.nix
  ];

  home = {
    packages = with pkgs; [
      android-studio
      lact
      nvtopPackages.amd
      obs-studio
      podman-compose
      poppler_utils
      rpi-imager
      steamcmd
      xsane
      ryujinx
    ];

    pointerCursor.size = 20;
  };

  services.picom = {
    enable = false;
    backend = "glx";
    vSync = true;
  };

  xdg.configFile = {
    eww = {
      enable = false;
      recursive = true;
      source = ../config/eww;
      target = "eww";
    };
  };
}
