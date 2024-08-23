{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      wakeonlan
      zfs
    ];
  };
}
