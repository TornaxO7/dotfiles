{ config, pkgs, lib, ... }:
{
  imports = [
    ./i3.nix
  ];

  home.packages = import ./packages.nix { inherit pkgs; };
  services = import ./services.nix;
  xdg = import ./xdg.nix;
}
