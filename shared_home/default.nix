{ inputs, config, pkgs, lib, ... }:
{
  home = {
    packages = import ./packages.nix {
      inherit pkgs;
    };
    sessionPath = import ./session_paths.nix;

    keyboard = {
      layout = "de";
      variant = "bone";
    };

    language.base = "en_US.UTF-8";
    stateVersion = "23.05";
  };

  programs = import ./programs/default.nix {inherit pkgs lib;};
  services = import ./services.nix;
  xdg = import ./xdg.nix {inherit inputs config lib;};
}
