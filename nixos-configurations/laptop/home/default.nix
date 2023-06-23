{ config, pkgs, lib, ... }:
{
  imports = [
    ./i3.nix
    ./i3status-rs.nix
  ];
  home.packages = import ./packages.nix { inherit pkgs; };
}
