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

    layout = "de";
    xkbVariant = "bone";
  };
}
