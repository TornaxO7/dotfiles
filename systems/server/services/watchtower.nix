utils: { ... }:
{
  virtualisation.oci-containers.containers.watchtower = {
    image = "containrrr/watchtower";

    volumes = [
      "/var/run/podman/podman.sock:/var/run/docker.sock"
    ];

    environment = {
      TZ = "DE";
      WATCHTOWER_TIMEOUT = "30s";
      WATCHTOWER_NOTIFICATION_URL = "gotify://gotify.nas.local/A2PzIba.UUR1RzM/?title=Server+Watchtower&priority=1";
    };
  };
}
