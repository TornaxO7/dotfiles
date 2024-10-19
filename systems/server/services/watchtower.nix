{ ... }:
{
  virtualisation.oci-containers.containers.watchtower = {
    image = "containrrr/watchtower";

    volumes = [
      "/var/run/podman/podman.sock:/var/run/docker.sock"
    ];

    environment = {
      TZ = "DE";
    };
  };
}
