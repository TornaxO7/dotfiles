{ root-domain, ... }:
let
  domain = root-domain;
  prefix = "miasma";
  port = 49195;
in
{
  virtualisation.oci-containers.containers.miasma = {
    image = "docker.io/austinweeks/miasma:latest";

    cmd = [
      "--link-prefix"
      "/naughty-bots"
      "--max-in-flight"
      "64"
      "--metrics-db-path"
      "/metrics/data.db"
      "--metrics-username"
      "tornax"
      "--metrics-password"
      "tornax"
    ];

    volumes = [
      "miasma-metrics:/metrics"
    ];

    ports = [
      "127.0.0.1:${toString port}:9999"
    ];

    labels = {
      "io.containers.autoupdate" = "registry";

      "traefik.enable" = "true";
      "traefik.http.routers.${prefix}.rule" = "Host(`${domain}`) && PathPrefix(`/naughty-bots`)";
      "traefik.http.routers.${prefix}.service" = prefix;
      "traefik.http.services.${prefix}.loadbalancer.server.port" = "9999";
    };
  };
}
