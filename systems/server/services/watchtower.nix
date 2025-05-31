{ ... }:
{
  virtualisation.oci-containers.containers.watchtower = {
    image = "containrrr/watchtower";

    volumes = [
      "/var/run/podman/podman.sock:/var/run/docker.sock"
    ];

    environment = {
      TZ = "DE";
      WATCHTOWER_TIMEOUT = "1m";
      WATCHTOWER_HTTP_API_TOKEN = "hello there";
      WATCHTOWER_HTTP_API_METRICS = "true";
    };
  };
}
