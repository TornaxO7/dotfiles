{ config, pkgs, services-root, ... }:
let
  utils = import ./utils.nix;
  network-name = "monitoring-network";

  paths = rec {
    root = "${services-root}/monitoring";
    prometheus = "${root}/prometheus";
    grafana = "${root}/grafana";
  };

  names = utils.createContainerNames "monitor" [
    "grafana"
    "prometheus"
    "node-exporter"
  ];
in
{
  systemd = {
    tmpfiles.settings = {
      monitoring-root = utils.createDirs config [ paths.root ];
      monitoring-dirs = utils.createDirs config (with paths; [ prometheus grafana ]);
    };

    services = {
      create-monitoring-network = utils.createPodmanNetworkService pkgs network-name (builtins.attrValues names.service-full);
    };
  };

  virtualisation.oci-containers.containers = {
    "${names.containers.grafana}" = {
      image = "grafana/grafana-enterprise";

      user = config.users.users.main.name;

      environment = {
        GF_FEATURE_TOGGLES_ENABLE = "externalServiceAccounts";
        GF_INSTALL_PLUGINS = "grafana-oncall-app";
      };

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.grafana.rule" = "Host(`monitoring.tornaxo7.de`)";
        "traefik.http.routers.grafana.service" = names.containers.grafana;
        "traefik.http.services.${names.containers.grafana}.loadbalancer.server.port" = "3000";
        "traefik.http.routers.grafana.tls" = "true";
        "traefik.http.routers.grafana.tls.certresolver" = "main";
      };

      volumes = [
        "${paths.grafana}:/var/lib/grafana"
        "/etc/passwd:/etc/passwd:ro"
      ];

      extraOptions = [ "--network=${network-name}" ];
    };

    "${names.containers.prometheus}" = {
      image = "prom/prometheus";

      volumes = [
        "${paths.prometheus}:/etc/prometheus"
      ];

      extraOptions = [ "--network=${network-name}" ];
    };

    "${names.containers.node-exporter}" = {
      image = "quay.io/prometheus/node-exporter:latest";
      cmd = [ "--path.rootfs=/host" ];
      extraOptions = [ "--network=${network-name}" ];
      volumes = [
        "/:/host:ro,rslave"
      ];
    };
  };
}
