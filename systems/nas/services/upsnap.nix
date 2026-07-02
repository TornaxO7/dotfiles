{ root-domain, ... }:
let
  domain = "upsnap.${root-domain}";
in
{
  virtualisation.oci-containers.conatiners.upsnap = {
    image = "ghcr.io/seriousm4x/upsnap:5";

    cmd = [
      "--network=host"
    ];

    volumes = [
      "upsnap:/app/pb_data"
    ];

    capabilties = {
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
