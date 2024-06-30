{ username, ... }:
{
  config = {
    systemd.tmpfiles.settings.syncthing = {
      "/var/lib/syncthing".d.user = username;
    };

    services.syncthing = {
      enable = true;
      user = username;
      relay.enable = false;
      openDefaultPorts = true;
      guiAddress = "100.88.51.57:8040";
    };
  };
}
