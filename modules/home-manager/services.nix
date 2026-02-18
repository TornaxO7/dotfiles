{ pkgs, ... }:
{
  services = {
    gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-curses;
    };

    # ssh-agent.enable = true;
  };
}
