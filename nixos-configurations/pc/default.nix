{ config, pkgs, lib, home-manager, ... }:
{
  environment.systemPackages = with pkgs; [
    i3
    neovim
    alacritty
    git
    google-chrome
  ] ++ import ../shared/desktop/packages.nix { inherit pkgs; };

  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.tornax.imports = [
          ../../shared_home/default.nix
          ./home/default.nix
        ];
      };
    }
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  networking.hostName = "pc";
  time.timeZone = "Europe/Berlin";

  services.printing.enable = true;
}
