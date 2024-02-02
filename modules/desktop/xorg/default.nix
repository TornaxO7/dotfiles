{ ... }:
{
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+i3";
    };

    xkb = {
      layout = "de";
      variant = "bone";
    };
  };
}
