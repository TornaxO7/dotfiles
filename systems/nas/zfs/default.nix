{ config, username, pkgs, ... }:
let
  ip-address = "100.88.51.57";
  zpool-name = "hdds";
  zpool-root = "/${zpool-name}";

  paperless-dir = "${zpool-root}/paperless";
in
{
  imports = [ ];

  config = {
    boot = {
      kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
      supportedFilesystems = [ "zfs" ];
      zfs.extraPools = [ zpool-name ];
    };

    systemd = {
      services."zpool-check" = {
        script = ''
          STATUS=$(${pkgs.zfs}/bin/zpool get -H health ${zpool-name} | ${pkgs.gawk}/bin/awk '{print $3}')

          if [[ "$STATUS" != "ONLINE" ]]; then
            ${pkgs.curl}/bin/curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"zpool has a problem!\"}" $(${pkgs.coreutils}/bin/cat ${config.age.secrets.discord-webhook.path})
          else
            ${pkgs.curl}/bin/curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"zpool is clean.\"}" $(${pkgs.coreutils}/bin/cat ${config.age.secrets.discord-webhook.path})
          fi
        '';

        wants = [ "zfs-scrub.service" ];
        after = [ "zfs-scrub.service" ];

        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
    };

    services = {
      grafana = {
        enable = false;
        settings = {
          server = {
            http_addr = ip-address;
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
        enable = false;

        globalConfig = {
          scrape_interval = "15s";
          evaluation_interval = "15s";
        };

        alertmanagers = [{
          static_configs = [{
            targets = [ "localhost:9093" ];
          }];
        }];

        ruleFiles = [
          ./zfs-pool-degraded-alert.yml
          ./test_alert.yml
        ];

        alertmanager =
          let
            receiver = "discord";
          in
          {
            enable = true;
            logFormat = "logfmt";
            configuration = {
              route = {
                group_by = [ "alertname" "job" ];

                group_wait = "30s";
                group_interval = "5m";
                repeat_interval = "3h";

                inherit receiver;
              };

              receivers = [{
                name = receiver;
                discord_configs = [{
                  send_resolved = true;
                  webhook_url_file = config.age.secrets.discord-webhook.path;
                }];
              }];
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
        address = "127.0.0.7";

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
          interval = "daily";
        };

        trim = {
          enable = true;
          interval = "quarterly";
        };
      };
    };
  };
}
