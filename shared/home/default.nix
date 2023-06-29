{ config, pkgs, lib, ... }:
{
  imports = [
    ./packages.nix
    ./session_paths.nix
    ./programs/default.nix
    ./services.nix
    ./xdg.nix
  ];

  config.home = {
    keyboard = {
      layout = "de";
      variant = "bone";
    };

    language.base = "en_US.UTF-8";
    stateVersion = "23.05";
  };
}
