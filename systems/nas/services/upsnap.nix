{ root-domain, ... }:
let
  domain = "upsnap.${root-domain}";
in
{
  virtualisation.oci-containers.containers.upsnap = {
    image = "ghcr.io/seriousm4x/upsnap:5";

    cmd = [
      "--network=host"
    ];

    volumes = [
      "upsnap:/app/pb_data"
    ];

    capabilities = {
      NET_RAW = true;
    };

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.upsnap.rule" = "Host(`${domain}`)";
      "traefik.http.routers.upsnap.service" = "upsnap";
      "traefik.http.services.upsnap.loadbalancer.server.port" = "8090";
    };
  };
}
