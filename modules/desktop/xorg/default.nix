{ ... }:
{
  services = {
    displayManager = {
      defaultSession = "none+i3";
    };

    xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
      };

      xkb = {
        layout = "de";
        variant = "bone";
      };
    };
  };
}
