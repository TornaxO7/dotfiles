{ ... }:
{
  config = {
    virtualisation.oci-containers.containers.microbin = {
      image = "docker.io/danielszabo99/microbin";

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.microbin.rule" = "Host(`microbin.local`)";
        "traefik.http.routers.microbin.service" = "microbin";
        "traefik.http.services.microbin.loadbalancer.server.port" = toString 8080;
      };
    };
  };
}
