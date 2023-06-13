{ config, pkgs, lib, ... }:
{
  home = {
    packages = import ./packages.nix {inherit pkgs;};
    services = import ./services.nix;
  };
}
