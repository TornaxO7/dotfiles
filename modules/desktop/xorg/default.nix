{ ... }:
{
  services = {
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
