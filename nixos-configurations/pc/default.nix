{ config, pkgs, lib, home-manager, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    home-manager.users.tornax.imports = [
      ../../shared/home/desktop/default.nix
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

    networking.hostName = "pc";
    time.timeZone = "Europe/Berlin";

    services.printing.enable = true;
  };
}
