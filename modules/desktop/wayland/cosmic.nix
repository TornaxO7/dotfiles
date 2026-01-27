{ pkgs, ... }:
{
  config = {
    users.users.tornax.packages = with pkgs; [
      wl-clipboard
    ];

    services = {
      desktopManager.cosmic.enable = true;
      displayManager.cosmic-greeter.enable = true;
    };

    environment.cosmic.excludePackages = with pkgs; [
      cosmic-term
      cosmic-edit
      cosmic-store
      cosmic-files
      cosmic-wallpapers
      cosmic-initial-setup
    ];
  };
}
