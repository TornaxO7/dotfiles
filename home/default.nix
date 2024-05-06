{ ... }:
let
  # only shared as long I only have PC and LAPTOP
  forTheTimeBeingShared = [
    ./desktop/default.nix
    ./desktop/xorg/default.nix
    ./desktop/xorg/i3.nix
    ./syncthing.nix
  ];
in
{
  imports = [
    ./packages.nix
    ./session_paths.nix
    ./session_variables.nix
    ./programs
    ./services.nix
    ./xdg.nix
  ] ++ forTheTimeBeingShared;

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
