{ config, ... }:
{
  services = {
    prometheus = rec {
      enable = true;
      listenAddress = "127.0.0.1";
      port = 49170;

      exporters = {
        node = {
          enable = true;
          listenAddress = "127.0.0.1";
          port = 49171;
        };
      };

      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets = [ "${exporters.node.listenAddress}:${toString exporters.node.port}" ];
            }
          ];
        }
      ];
    };

    # grafana
    grafana.provision.datasources.settings.datasources = [
      {
        name = "Prometheus";
        type = "prometheus";
        url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
      }
    ];
  };
}
