utils: { config, lib, pkgs, zpool-name, zpool-root, domain-root, services-root, ... }:
let
  # ZFS dataset
  backup-root = "${zpool-root}/paperless";

  binds = rec {
    backup = "${backup-root}/backup";

    service-root = "${services-root}/paperless";
    consume = "${service-root}/consume";
  };

  volumes = {
    data = "paperless-data";
    media = "paperless-media";
    db-data = "paperless-db-data";
  };

  names = utils.createContainerNames "paperless" [ "server" "postgres" "redis" ];

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

          ${names.service-prefixes.server}.requires = with names.service-full; [ postgres redis ];
          ${names.service-prefixes.postgres}.requires = with names.service-full; [ redis ];

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
            OnCalendar = "daily";
            Persistent = true;
          };
        };
      }
      (utils.createSystemdZfsSnapshot pkgs "paperless" "${zpool-name}/paperless");


    virtualisation.oci-containers.containers = {
      ${names.containers.server} = {
        image = "ghcr.io/paperless-ngx/paperless-ngx:latest";
        environment = {
          PAPERLESS_DBHOST = "${names.containers.postgres}";
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
      };

      ${names.containers.redis} = {
        image = "docker.io/library/redis:7";
        extraOptions = [ "--network=${network-name}" ];
      };

      ${names.containers.postgres} = {
        image = "docker.io/library/postgres:16";
        environment = {
          "POSTGRES_DB" = "paperless";
          "POSTGRES_USER" = "paperless";
          "POSTGRES_PASSWORD" = "paperless";
        };
        extraOptions = [
          "--network=${network-name}"
        ];
        volumes = [
          "${volumes.db-data}:/var/lib/postgresql/data"
        ];
      };
    };
  };
}

