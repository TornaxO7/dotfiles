{ config, pkgs, lib, ... }:
{
  home = {
    packages = import ./packages.nix
      {
        inherit pkgs;
      } ++ import ../shared_home/desktop/packages.nix { inherit pkgs; };
  };
  services = import ./services.nix;
  xsession = import ./xsession.nix;
}
