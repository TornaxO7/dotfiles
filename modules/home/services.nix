{ ... }:
{
  services = {
    gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      enableSshSupport = true;
    };

    kdeconnect.enable = true;
    };
}
