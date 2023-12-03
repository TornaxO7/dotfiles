{ ... }:
{
  services = {
    gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      enableSshSupport = true;
    };

    gnome-keyring.enable = true;
  };
}
