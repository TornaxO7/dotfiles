{ ... }:
{
  services = {
    gpg-agent = {
      enable = true;
      pinentryFlavor = "tty";
    };

    ssh-agent.enable = true;
  };
}
