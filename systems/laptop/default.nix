{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./wireguard.nix
    ./home

    ../../modules/default_main.nix
    ../../modules/desktop/default.nix
    ../../modules/desktop/xorg/default.nix
    ../../modules/desktop/xorg/i3.nix
    ../../modules/desktop/wayland/cosmic.nix
    ../../modules/yubikey.nix
    ../../modules/kdeconnect.nix

    ./users
  ];

  config = {
    hardware.bluetooth.enable = true;
    documentation.dev.enable = true;

    environment = {
      variables = {
        GDK_SCALE = "2";
        GDK_DPI_SCALE = "0.5";
        QT_AUTO_SCREEN_SCALE_FACTOR = "True";
      };
    };

    services = {
      blueman.enable = true;
      displayManager = {
        defaultSession = "cosmic";
        autoLogin = {
          enable = true;
          user = config.users.users.tornax.name;
        };
      };

      desktopManager.plasma6.enable = true;

      xserver = {
        dpi = 210;

        windowManager.i3 = {
          enable = config.services.xserver.enable;
        };
      };
    };

    virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vboxusers.members = [ config.users.users.tornax.name ];

    networking = {
      networkmanager.enable = true;
    };

    programs = {
      steam.enable = true;
      nm-applet.enable = true;
    };
    services = {
      printing.enable = true;
      flatpak.enable = true;
    };

    # to have audio
    boot.extraModprobeConfig = ''
      options snd-hda-intel dmic_detect=0
    '';
  };
}
