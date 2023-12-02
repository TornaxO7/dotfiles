{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/desktop/default.nix
    ../../modules/desktop/xorg/default.nix
    ../../modules/desktop/xorg/i3.nix
    ../../modules/game/steam.nix
    ../../modules/yubikey
    ../../modules/udev_moonlander_rules.nix
    ../../modules/kdeconnect.nix
    ../../modules/paperless/default.nix
  ];

  config = {
    services.xserver = {
      displayManager = {
        defaultSession = "none+i3";
        autoLogin = {
          enable = true;
          user = "tornax";
        };
      };

      # desktopManager.gnome.enable = true;
      desktopManager.plasma5.enable = true;
    };

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        efi.efiSysMountPoint = "/boot";
      };

      initrd.kernelModules = [ "amdgpu" ];
    };

    hardware.opengl.driSupport = true;

    networking = {
      networkmanager.enable = false;
      hostName = "pc";
      interfaces.enp6s0.wakeOnLan.enable = true;
    };
    time.timeZone = "Europe/Berlin";

    services.printing.enable = true;
  };
}
