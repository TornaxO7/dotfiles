{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      zfs
    ];
  };
}
