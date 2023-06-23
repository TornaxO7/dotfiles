{ config, pkgs, lib, ... }:
{
  home.packages = import ./packages.nix { inherit pkgs; };
  programs = import ./programs.nix;
  xdg = import ./xdg.nix;
}
