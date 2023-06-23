{ config, pkgs, lib, ... }:
{
  imports = [
    ./i3.nix
  ];
  home.packages = import ./packages.nix { inherit pkgs; };
  programs = import ./programs.nix;
  xdg = import ./xdg.nix;
}
