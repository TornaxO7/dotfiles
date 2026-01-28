{ pkgs, ... }:
{
  home-manager.users.tornax = { ... }: {
    config = {
      home.packages = with pkgs; [
        systemctl-tui
        wakeonlan
        zfs
      ];
    };
  };
}
