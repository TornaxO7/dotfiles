{ ... }:
{
  services = {
    xserver = {
      enable = true;

      displayManager.startx.enable = true;

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
