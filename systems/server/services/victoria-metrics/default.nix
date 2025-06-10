{ ... }:
let
  ports = {
    metrics = 49170;
  };
in
{
  virtualisation.oci-containers.containers = {
    victoria = {
      image = "victoriametrics/victoria-metrics:v1.119.0";

      volumes = [
        "victoria-storage:/storage"
        "${./prometheus.yml}:/etc/prometheus/prometheus.yml"
      ];

      ports = [
        "127.0.0.1:${toString ports.metrics}:8428"
      ];

      cmd = [
        "--storageDataPath=/storage"
        "--httpListenAddr=:8428"
        "--promscrape.config=/etc/prometheus/prometheus.yml"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.victoria.rule" = "Host(`victoria.tornaxo7.de`)";
        "traefik.http.routers.victoria.service" = "victoria";
        "traefik.http.routers.victoria.middlewares" = "authelia@file";
        "traefik.http.services.victoria.loadbalancer.server.port" = "8428";
      };
    };

    node-exporter = {
      image = "quay.io/prometheus/node-exporter:latest";

      volumes = [
        "/:/host:ro,rslave"
      ];

      cmd = [
        "--path.rootfs=/host"
      ];
    };
  };

  # grafana
  services.grafana.provision.datasources.settings.datasources = [
    {
      name = "Victoria";
      type = "prometheus";
      url = "http://127.0.0.1:${toString ports.metrics}";
    }
  ];
}
