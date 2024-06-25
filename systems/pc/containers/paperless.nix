{ config }:
{
  config = { pkgs, ... }: {
    services.paperless = {
      enable = true;
      passwordFile = config.age.secrets.paperless.path;
      address = config.networking.hostName;
    };

    system.stateVersion = config.system.stateVersion;
  };
}
