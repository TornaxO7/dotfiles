{ ... }:
{
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    layout = "de";
    xkbVariant = "bone";
  };
}
