{ wg0, tld, ... }:
let
  domain = tld;
  domain-vpn = "miasma.${wg0.small.host}";
  prefix = "miasma";
  prefix-metrics = "${prefix}-metrics";
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

    labels = {
      "io.containers.autoupdate" = "registry";

      "traefik.enable" = "true";
      "traefik.http.routers.${prefix}.rule" = "Host(`${domain}`) && PathPrefix(`/naughty-bots`)";
      "traefik.http.routers.${prefix}.service" = prefix;
      "traefik.http.services.${prefix}.loadbalancer.server.port" = "9999";

      "traefik.http.middlewares.${prefix-metrics}-path.replacePath.path" = "/metrics";
      "traefik.http.routers.${prefix-metrics}-metrics.rule" = "Host(`${domain-vpn}`)";
      "traefik.http.routers.${prefix-metrics}-metrics.middlewares" = "${prefix-metrics}-path";
      "traefik.http.routers.${prefix-metrics}-metrics.entryPoints" = "https-vpn";
      "traefik.http.routers.${prefix-metrics}-metrics.service" = "${prefix-metrics}";
      "traefik.http.services.${prefix-metrics}.loadbalancer.server.port" = "9999";
    };
  };
}
