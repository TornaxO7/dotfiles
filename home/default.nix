{ config, pkgs, lib, self, ... }:
{
  imports = [
    ./packages.nix
    ./session_paths.nix
    ./programs.nix
    ./services.nix
    ./xdg.nix
  ];

  config = {
    home = {
      username = "tornax";
      homeDirectory = "/home/tornax";

      keyboard = {
        layout = "de";
        variant = "bone";
      };

      language.base = "en_US.UTF-8";
      stateVersion = "23.05";
    };

    nixpkgs.config.allowUnfree = true;
  };
}
