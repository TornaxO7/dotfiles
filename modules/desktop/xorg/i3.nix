{ pkgs, ... }:
{
  services = {
    displayManager = {
      defaultSession = "none+i3";
    };

    xserver.windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
        xwallpaper
      ];
    };
  };
}
