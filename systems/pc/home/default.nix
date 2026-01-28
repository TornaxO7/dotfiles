{ pkgs, ... }:
{
  home-manager.users.tornax = { ... }: {
    imports = [
      ./minecraft.nix
      ../../../home/client.nix
    ];

    config = {
      home = {
        packages = with pkgs; [
          easyeffects
          lact
          nvtopPackages.amd
          obs-studio
          podman-compose
          poppler-utils
          rpi-imager
          steamcmd
          xsane

          github-copilot-cli
        ];

        # pointerCursor.size = 20;
      };

      services = {
        picom = {
          enable = false;
          backend = "glx";
          vSync = true;
        };
      };

      xdg.configFile = {
        eww = {
          enable = false;
          recursive = true;
          source = ../config/eww;
          target = "eww";
        };
      };
    };
  };
}
