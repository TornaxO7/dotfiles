username: { config, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/default_main.nix
    ../../modules/desktop/default.nix
    ../../modules/desktop/xorg/default.nix
    ../../modules/desktop/wayland/cosmic.nix
    ../../modules/desktop/xorg/i3.nix
    ../../modules/game/steam.nix
    ../../modules/yubikey.nix
    ../../modules/udev_moonlander_rules.nix
    ../../modules/kdeconnect.nix
  ];

  config = {
    services = {
      displayManager = {
        defaultSession = "none+i3";
        autoLogin = {
          enable = true;
          user = username;
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
