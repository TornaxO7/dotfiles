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
          gdb
          lact
          nvtopPackages.amd
          obs-studio
          godot
          podman-compose
          poppler-utils
          rpi-imager
          steamcmd
          xsane
          bugstalker

          github-copilot-cli
          yubikey-personalization
        ];

        # pointerCursor.size = 20;
      };

      services = {
        picom = {
          enable = false;
          backend = "glx";
          vSync = true;
        };

        ssh-agent.enable = true;
        # yubikey-agent.enable = true;
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
