{ config, pkgs, lib, home-manager, ... }:
{

  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    home-manager.users.tornax.imports = [
      ../../shared/home/desktop/default.nix
      ../../shared/home/desktop/wm/i3.nix
      ./home/default.nix
    ];

    environment = {
      systemPackages = with pkgs; [
        alacritty
      ];

      variables = {
        GDK_SCALE = "2";
        GDK_DPI_SCALE = "0.5";
        QT_AUTO_SCREEN_SCALE_FACTOR = "2";
      };
    };

    services.xserver = {
      dpi = 210;
      displayManager = {
        defaultSession = "none+i3";
        autoLogin = {
          enable = true;
          user = "tornax";
        };
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          xwallpaper
        ];
      };
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";

    networking = {
      hostName = "laptop";
      networkManager = {
        enable = true;
      };
    };

    programs.nm-applet.enable = true;

    time.timeZone = "Europe/Berlin";

    services.printing.enable = true;
  };
}
