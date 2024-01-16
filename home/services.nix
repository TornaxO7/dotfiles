{ ... }:
{
  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryFlavor = "curses";
    };

    syncthing.enable = true;
  };
}
