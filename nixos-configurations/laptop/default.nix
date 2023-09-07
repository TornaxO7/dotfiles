{ config, pkgs, lib, home-manager, ... }:
{

  imports = [
    ./hardware-configuration.nix

    ../../modules/desktop/default.nix
    ../../modules/desktop/xorg.nix
    ../../modules/yubikey/default.nix
  ];

  config = {
    home-manager.users.tornax.imports = [
      ../../modules/home/desktop/default.nix
      ../../modules/home/desktop/xorg/default.nix
      ../../modules/home/desktop/xorg/i3.nix
      ./home/default.nix
    ];

    hardware.bluetooth.enable = true;

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

    services = {
      blueman.enable = true;
      xserver = {
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
    };


    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";

    networking = {
      hostName = "laptop";
      networkmanager.enable = true;
    };

    programs.nm-applet.enable = true;

    time.timeZone = "Europe/Berlin";

    services.printing.enable = true;
  };
}
