{ config, ... }:
{

  services = {
    prometheus = {
      exporters = {
        node = {
          enable = true;
          listenAddress = "127.0.0.1";
          port = 49170;
        };
      };
    };

    victoriametrics = {
      enable = true;
      listenAddress = "127.0.0.1:8428";
      prometheusConfig = {
        scrape_configs = [
          {
            job_name = "node";

            static_configs =
              let
                node = config.services.prometheus.exporters.node;
              in
              [
                {
                  targets = [ "${node.listenAddress}:${toString node.port}" ];
                }
              ];
          }
        ];
      };
    };

    # grafana
    grafana.provision.datasources.settings.datasources = [
      {
        name = "Prometheus";
        type = "prometheus";
        url = "http://${config.services.victoriametrics.listenAddress}";
      }
    ];
  };
}
