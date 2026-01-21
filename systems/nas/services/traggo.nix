{ root-domain, ... }:
let
  domain = "traggo.${root-domain}";
in
{
  virtualisation.oci-containers.containers.traggo = {
    image = "traggo/server:latest";
    volumes = [
      "traggo:/opt/traggo/data"
    ];

    environment = {
      "TRAGGO_DEFAULT_USER_NAME" = "tornax";
      "TRAGGO_DEFAULT_USER_PASS" = "tornax";
    };

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.traggo.rule" = "Host(`${domain}`)";
      "traefik.http.routers.traggo.service" = "traggo";
      "traefik.http.services.traggo.loadbalancer.server.port" = "3030";
    };
  };
}
