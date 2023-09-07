{ pkgs, ... }:
{
  services.xserver = {
    displayManager = {
      defaultSession = "none+i3";
      autoLogin = {
        enable = true;
        user = "tornax";
      };
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
        xwallpaper
      ];
    };
  };
}
