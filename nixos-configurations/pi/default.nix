{ config, pkgs, lib, home-manager, ... }:
{
  imports = [
  ];

  config = {
    home-manager.users.tornax.imports = [
      ./home/default.nix
    ];
    time.timeZone = "Europe/Berlin";

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";
  };
}
