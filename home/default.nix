{ config, pkgs, lib, ... }:
{
  home = {
    # packages = import ./packages.nix {
    #   inherit pkgs;
    # };
    # sessionPath = import ./session_paths.nix;

    keyboard = {
      layout = "de";
      variant = "bone";
    };

    language.base = "en";
    stateVersion = "23.05";
  };

  # programs = import ./programs.nix {inherit lib;};
  # services = import ./services.nix;
}