{ pkgs, ... }:
{
  services = {
    gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-tty;
    };

    ssh-agent.enable = true;
  };
}
