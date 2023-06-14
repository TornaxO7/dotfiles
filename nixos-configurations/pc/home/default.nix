{ config, pkgs, lib, ... }:
{
  home = {
    packages = import ./packages.nix
      {
        inherit pkgs;
      };
  };
  programs = import ./programs.nix;
  services = import ./services.nix;
  xsession = import ./xsession.nix;
  xdg = import ./xdg.nix;
}
