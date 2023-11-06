{ ... }:
{
  services = {
    gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      enableSshSupport = true;
    };

    ssh-agent.enable = true;
  };
}
