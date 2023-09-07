{ config, pkgs, lib, home-manager, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/desktop/default.nix
    ../../modules/desktop/xorg.nix
    ../../modules/game/steam.nix
    ../../modules/yubikey
    ../../modules/udev_moonlander_rules.nix
  ];

  config = {
    home-manager.users.tornax.imports = [
      ../../modules/home/desktop/default.nix
      ../../modules/home/desktop/xorg/default.nix
      ../../modules/home/desktop/xorg/i3.nix
      ./home/default.nix
    ];

    environment.systemPackages = with pkgs; [
      alacritty
    ];

    services.xserver = {
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
          rofi
          xwallpaper
        ];
      };

      desktopManager.gnome.enable = true;
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
