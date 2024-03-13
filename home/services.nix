{ ... }:
{
  services = {
    gpg-agent = {
      enable = true;
      pinentryFlavor = "curses";
    };

    ssh-agent.enable = true;
  };
}
