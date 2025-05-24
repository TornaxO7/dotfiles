{ pkgs, ... }:
{
  config = {
    users.users.main.packages = with pkgs; [
      wl-clipboard
    ];

    services = {
      desktopManager.cosmic.enable = true;
      displayManager.cosmic-greeter.enable = true;
    };
  };
}
