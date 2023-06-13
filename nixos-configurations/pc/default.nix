{ config, pkgs, lib, ... }:
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
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  networking.hostName = "pc";
  time.timeZone = "Europe/Berlin";

  services.printing.enable = true;
}
