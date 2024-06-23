{ ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/desktop/default.nix
    ../../modules/desktop/xorg/default.nix
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
    };

    boot.initrd.kernelModules = [ "amdgpu" ];

    hardware.opengl.driSupport = true;

    networking = {
      networkmanager.enable = false;
      hostName = "pc";
      interfaces.enp6s0.wakeOnLan.enable = true;
    };

    services.printing.enable = true;
  };
}
