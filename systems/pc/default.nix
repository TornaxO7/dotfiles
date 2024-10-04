{ ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/desktop/default.nix
    ../../modules/desktop/xorg/default.nix
    ../../modules/desktop/wayland/cosmic.nix
    ../../modules/desktop/xorg/i3.nix
    ../../modules/game/steam.nix
    ../../modules/yubikey/default.nix
    ../../modules/udev_moonlander_rules.nix
    ../../modules/kdeconnect.nix
  ];

  config = {
    services = {
      displayManager = {
        defaultSession = "none+i3";
        autoLogin = {
          enable = true;
          user = "tornax";
        };
      };
      printing.enable = true;
    };

    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.opengl = {
      enable = true;
      driSupport = true;
    };

    networking = {
      networkmanager.enable = false;
      interfaces.enp6s0.wakeOnLan.enable = true;
    };
  };
}
