{ pkgs, ... }:
{
  config = {
    programs.fish.shellAliases = {
      stui = "systemctl-tui";
    };

    home.packages = with pkgs; [
      systemctl-tui
      wakeonlan
      zfs
    ];
  };
}
