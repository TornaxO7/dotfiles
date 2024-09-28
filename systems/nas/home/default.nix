{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      systemctl-tui
      wakeonlan
      zfs
    ];
  };
}
