{ pkgs, ... }:
{
  services = {
    gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
    };

    ssh-agent.enable = true;
  };
}
