{ root-domain, zpool-root, ... }:
let
  domain = "timetagger.${root-domain}";
in
{
  virtualisation.oci-containers.containers.timetagger = {
    image = "ghcr.io/almarklein/timetagger";

    volumes = [
      "${zpool-root}/timetagger:/root/_timetagger"
    ];

    environment = {
      "TIMETAGGER_BIND" = "0.0.0.0:80";
      "TIMETAGGER_DATADIR" = "/root/_timetagger";
      "TIMETAGGER_LOG_LEVEL" = "info";
      "TIMETAGGER_CREDENTIALS" = "tornax:$2y$10$isVZQlPuBvPcCc1PlPbUOe6qPSqaSheBSUXkhgNxHgVTFqUyIEiaO";
    };

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.timetagger.rule" = "Host(`${domain}`)";
      "traefik.http.routers.timetagger.service" = "timetagger";
      "traefik.http.services.timetagger.loadbalancer.server.port" = "80";
    };
  };
}
