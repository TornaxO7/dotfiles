{ config, pkgs, lib, home-manager, ... }:
{

  environment.systemPackages = with pkgs; [
    alacritty
  ];

  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    QT_AUTO_SCREEN_SCALE_FACTOR = "2";
  };

  imports = [
    ./hardware-configuration.nix
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  networking = {
    hostName = "laptop";
    wireless.iwd.enable = true;
  };
  time.timeZone = "Europe/Berlin";

  services.printing.enable = true;
}
