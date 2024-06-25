{ config, username, ... }:
let
  address = "100.88.51.57";

  zpool-name = "hdds";
  zpool-root = "/${zpool-name}";

  paperless-dir = "${zpool-root}/paperless";

  nas-mail = "tornax.nas@gmail.com";
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    boot = {
      kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
      supportedFilesystems = [ "zfs" ];
      zfs.extraPools = [ zpool-name ];
    };

    services = {
      grafana = {
        enable = true;
        settings = {
          server = {
            http_addr = address;
            http_port = 3000;
          };

          log = {
            mode = "file";
            level = "error";
          };
        };

        provision = {
          # dashboards.settings.providers = [{
          #   name = "default";
          #   options.path = "/var/lib/grafana/dashboards";
          # }];

          datasources.settings.datasources = [{
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://localhost:9090/";
          }];
        };
      };

      prometheus = {
        enable = true;

        globalConfig = {
          scrape_interval = "15s";
          evaluation_interval = "15s";
        };

        ruleFiles = [
          ./tmp_alert.yml
        ];

        alertmanagers = [
          {
            static_configs = [
              {
                targets = [ "localhost:9093" ];
              }
            ];
          }
        ];

        alertmanager = {
          enable = true;
          configuration = {
            route = {
              group_by = [ "alertname" "job" ];
              group_wait = "30s";
              group_interval = "5m";
              repeat_interval = "3h";

              receiver = "discord";
            };

            receivers = {
              name = "discord";
              discord_configs = {
                webhook_url = config.age.secrets.discord-webhook.path;
              };
            };
          };
        };

        scrapeConfigs = [
          {
            job_name = "node";
            static_configs = [{
              targets = [
                " localhost:${toString config.services.prometheus.exporters.node.port}"
              ];
            }];
          }
          {
            job_name = "zfs";
            static_configs = [{
              targets = [
                "localhost:${toString config.services.prometheus.exporters.zfs.port}"
              ];
            }];
          }
          {
            job_name = "demo";
            static_configs = [{
              targets = [
                "demo.promlabs.com:10000"
                "demo.promlabs.com:10001"
                "demo.promlabs.com:10002"
              ];
            }];
          }
        ];

        exporters = {
          node.enable = true;
          zfs.enable = true;
        };
      };

      paperless = {
        inherit address;

        enable = true;
        user = username;
        mediaDir = "${paperless-dir}/media";
        settings = {
          PAPERLESS_EMPTY_TRASH_DIR = "${config.services.paperless.dataDir}/media-trash";
        };
      };

      zfs = {
        autoScrub = {
          enable = true;
          interval = "weekly";
        };

        trim = {
          enable = true;
          interval = "quarterly";
        };
      };
    };

    networking = {
      hostId = "17b02087";
      networkmanager.enable = false;
      hostName = "nas";
    };
  };
}

