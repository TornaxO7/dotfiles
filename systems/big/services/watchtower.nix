{ ... }:
{
  virtualisation.oci-containers.containers.watchtower = {
    image = "nickfedor/watchtower";

    volumes = [
      "/var/run/podman/podman.sock:/var/run/docker.sock"
    ];

    environment = {
      TZ = "DE";
      WATCHTOWER_TIMEOUT = "1m";
      WATCHTOWER_INCLUDE_RESTARTING = "true";
    };
  };
}
