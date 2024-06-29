{ pkgs, ... }:
{
  imports = [
    ../../../home/syncthing.nix
  ];

  config = {
    home.packages = with pkgs; [
      zfs
    ];
  };
}
