utils: { config, ... }:
{
  virtualisation.oci-containers.containers.watchtower = {
    image = "containrrr/watchtower";

    volumes = [
      "/var/run/podman/podman.sock:/var/run/docker.sock"
    ];

    environment = {
      TZ = "DE";
      WATCHTOWER_NOTIFICATIONS = "gotify";
      WATCHTOWER_NOTIFICATION_GOTIFY_TLS_SKIP_VERIFY = "true";
      WATCHTOWER_NOTIFICATION_GOTIFY_URL = "http://gotify.nas.local";
      WATCHTOWER_NOTIFICATION_GOTIFY_TOKEN = config.age.secrets.gotify-token.path;
    };
  };
}

