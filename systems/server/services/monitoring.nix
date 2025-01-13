utils: { config, pkgs, services-root, domain-root, ... }:
let
  network-name = "monitoring-network";

  grafana-paths = rec {
    root = "${services-root}/monitoring";
    prometheus = "${root}/prometheus";
    grafana = "${root}/grafana";
  };

  headscale-paths = rec{
    root = "${services-root}/headscale";
    config = "${root}/config";
    lib = "${root}/lib";
  };

  headscale-names = utils.createContainerNames "headscale" [ "server" ];

  grafana-names = utils.createContainerNames "monitor" [
    "grafana"
    "prometheus"
    "node-exporter"
    "watchtower"
  ];

  grafana-domain = "monitoring.${domain-root}";
  headscale-domain = "headscale.${domain-root}";
in
{
  systemd = {
    tmpfiles.settings = {
      monitoring-dirs = utils.createDirs config (builtins.attrValues grafana-paths);
      headscale-dirs = utils.createDirs config (builtins.attrValues headscale-paths);
    };

    services = {
      create-monitoring-network = utils.createPodmanNetworkService pkgs network-name (builtins.attrValues grafana-names.service-full);
    };
  };

  virtualisation.oci-containers.containers = {
    "${grafana-names.containers.grafana}" = {
      image = "grafana/grafana-enterprise";

      user = config.users.users.main.name;

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.grafana.rule" = "Host(`${grafana-domain}`)";
        "traefik.http.routers.grafana.service" = grafana-names.containers.grafana;
        "traefik.http.services.${grafana-names.containers.grafana}.loadbalancer.server.port" = "3000";
        "traefik.http.routers.grafana.tls" = "true";
        "traefik.http.routers.grafana.tls.certresolver" = "main";
      };

      volumes = [
        "${grafana-paths.grafana}:/var/lib/grafana"
        "/etc/passwd:/etc/passwd:ro"
      ];

      extraOptions = [ "--network=${network-name}" ];
    };

    "${grafana-names.containers.prometheus}" = {
      image = "prom/prometheus";

      volumes = [
        "${grafana-paths.prometheus}:/etc/prometheus"
      ];

      extraOptions = [ "--network=${network-name}" ];
    };

    "${grafana-names.containers.node-exporter}" = {
      image = "quay.io/prometheus/node-exporter:latest";
      cmd = [ "--path.rootfs=/host" ];
      extraOptions = [ "--network=${network-name}" ];
      volumes = [
        "/:/host:ro,rslave"
      ];
    };

    ${grafana-names.containers.watchtower} = {
      image = "containrrr/watchtower";

      volumes = [
        "/var/run/podman/podman.sock:/var/run/docker.sock"
      ];

      environment = {
        TZ = "DE";
        WATCHTOWER_TIMEOUT = "1m";
        WATCHTOWER_HTTP_API_TOKEN = "hello there";
        WATCHTOWER_HTTP_API_METRICS = "true";
      };

      extraOptions = [ "--network=${network-name}" ];
    };

    # headscale stuff
    ${headscale-names.containers.server} = {
      image = "headscale/headscale:latest";

      volumes = [
        "${headscale-paths.config}:/etc/headscale"
        "${headscale-paths.lib}:/var/lib/headscale"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.${headscale-names.containers.server}.rule" = "Host(`${headscale-domain}`)";
        "traefik.http.routers.${headscale-names.containers.server}.service" = "${headscale-names.containers.server}";
        "traefik.http.services.${headscale-names.containers.server}.loadbalancer.server.port" = "8080";
        "traefik.http.routers.${headscale-names.containers.server}.tls" = "true";
        "traefik.http.routers.${headscale-names.containers.server}.tls.certresolver" = "main";
      };

      cmd = [ "serve" ];

      extraOptions = [ "--network=${network-name}" ];
    };
  };
}
