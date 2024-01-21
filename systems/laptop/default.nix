{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    hardware.bluetooth.enable = true;

    environment = {
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

    networking = {
      hostName = "laptop";
      networkmanager.enable = true;
    };

    programs.nm-applet.enable = true;
    services.printing.enable = true;
  };
}
