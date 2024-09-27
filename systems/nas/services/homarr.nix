{ zpool-root, ... }:
{
  virtualisation.oci-containers.containers.homarr = {
    image = "ghcr.io/ajnart/homarr:latest";

    volumes = [
      "/var/run/podman/podman.sock:/var/run/docker.sock"

      "${zpool-root}/homarr/configs:/app/data/configs"
      "${zpool-root}/homarr/icons:/app/public/icons"
      "${zpool-root}/homarr/data:/data"
    ];

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.homarr.rule" = "Host(`dashboard.local`)";
      "traefik.http.routers.homarr.service" = "homarr";
      "traefik.http.services.homarr.loadbalancer.server.port" = toString 7575;
    };
  };
}
