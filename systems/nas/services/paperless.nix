utils: { config, lib, pkgs, zpool-name, zpool-root, domain-root, services-root, ... }:
let
  # ZFS dataset
  backup-root = "${zpool-root}/paperless";

  binds = rec {
    backup = backup-root;

    service-root = "${services-root}/paperless";
    consume = "${service-root}/consume";
  };

  volumes = {
    data = "paperless-data";
    media = "paperless-media";
    db-data = "paperless-db-data";
  };

  names = utils.createContainerNames "paperless" [ "server" "redis" ];

  network-name = "paperless-network";
  domain = "paperless.${domain-root}";

  backup-service-name = "paperless-backup";
in
{
  config = {
    systemd = lib.attrsets.recursiveUpdate
      {
        tmpfiles.settings = {
          paperless = utils.createDirs config (builtins.attrValues binds);
        };

        services = {
          create-paperless-network = utils.createPodmanNetworkService pkgs network-name (builtins.attrValues names.service-full);

          ${backup-service-name} = {
            description = "Create backup of paperless";
            serviceConfig = {
              ExecStart = "${pkgs.podman}/bin/podman exec ${names.containers.server} ./manage.py document_exporter ../export";
              Type = "oneshot";
            };
          };
        };

        timers.${backup-service-name} = {
          description = "Create a backup of paperless";
          wantedBy = [ "multi-user.target" ];
          timerConfig = {
            # every three hour
            OnCalendar = "*-*-* 00,03,06,09,12,15,18,21:00:00";
            Persistent = true;
          };
        };
      }
      (utils.createSystemdZfsSnapshot pkgs "paperless" "${zpool-name}/paperless");


    virtualisation.oci-containers.containers = {
      ${names.containers.server} = {
        image = "ghcr.io/paperless-ngx/paperless-ngx:latest";
        environment = {
          PAPERLESS_REDIS = "redis://${names.containers.redis}:6379";
          PAPERLESS_OCR_USER_ARGS = "{\"continue_on_soft_render_error\": true}";
        };
        volumes = [
          "${volumes.data}:/usr/src/paperless/data"
          "${volumes.media}:/usr/src/paperless/media"
          "${binds.consume}:/usr/src/paperless/consume"
          "${binds.backup}:/usr/src/paperless/export"
        ];
        extraOptions = [ "--network=${network-name}" ];

        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.${names.containers.server}.rule" = "Host(`${domain}`)";
          "traefik.http.routers.${names.containers.server}.service" = "${names.containers.server}";
          "traefik.http.services.${names.containers.server}.loadbalancer.server.port" = "8000";
        };

        dependsOn = with names.containers; [ redis ];
      };

      ${names.containers.redis} = {
        image = "docker.io/library/redis:7";
        extraOptions = [ "--network=${network-name}" ];
      };
    };
  };
}

