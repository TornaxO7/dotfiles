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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  networking.hostName = "pc";
  time.timeZone = "Europe/Berlin";

  services.printing.enable = true;
}
