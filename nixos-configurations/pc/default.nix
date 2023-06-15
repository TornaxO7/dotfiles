{ config, pkgs, lib, home-manager, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
  ];

  imports = [
    ./hardware-configuration.nix
    ../shared/desktop/default.nix
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.tornax.imports = [
          ../../shared_home
          ../../shared_home/desktop
          ./home
        ];
      };
    }
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

    initrd.kernelModules = ["amdgpu"];
  };

  hardware.opengl.driSupport = true;

  networking.hostName = "pc";
  time.timeZone = "Europe/Berlin";

  services.printing.enable = true;
}
