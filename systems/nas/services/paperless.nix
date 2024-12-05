utils: { config, lib, pkgs, zpool-name, zpool-root, ... }:
let
  paperless-dir = "${zpool-root}/paperless";

  paperless-paths = {
    data = "${paperless-dir}/data";
    media = "${paperless-dir}/media";
    dbs = "/var/lib/paperless/data";
    consume = "/var/lib/paperless/consume";
  };

  names = utils.createContainerNames "paperless" [ "server" "postgres" "redis" ];

  network-name = "paperless-network";
in
{
  config = {
    systemd = lib.attrsets.recursiveUpdate
      {
        tmpfiles.settings = {
          "${names.containers.server}" = utils.createDirs config (builtins.attrValues paperless-paths);
        };

        services = {
          create-paperless-network = utils.createPodmanNetworkService pkgs network-name (builtins.attrValues names.service-full);

          # make sure that whenever a service gets restarted, everything gets correctly restarted
          "${names.service-prefixes.server}".requires = with names.service-full; [ postgres redis ];
          "${names.service-prefixes.postgres}".requires = with names.service-full; [ redis ];
        };
      }
      (utils.createSystemdZfsSnapshot pkgs "paperless" "${zpool-name}/paperless");


    virtualisation.oci-containers = {
      containers = {
        "${names.containers.server}" = {
          image = "ghcr.io/paperless-ngx/paperless-ngx:latest";
          environment = {
            PAPERLESS_DBHOST = "${names.containers.postgres}";
            PAPERLESS_REDIS = "redis://${names.containers.redis}:6379";
            PAPERLESS_OCR_USER_ARGS = "{\"continue_on_soft_render_error\": true}";
          };
          volumes = [
            "${paperless-paths.data}:/usr/src/paperless/data"
            "${paperless-paths.media}:/usr/src/paperless/media"
            "${paperless-paths.consume}:/usr/src/paperless/consume"
          ];
          extraOptions = [ "--network=${network-name}" ];

          labels = {
            "traefik.enable" = "true";
            "traefik.http.routers.paperless.rule" = "Host(`paperless.nas.local`)";
            "traefik.http.routers.paperless.service" = "paperless";
            "traefik.http.services.paperless.loadbalancer.server.port" = toString 8000;
          };
        };

        "${names.containers.redis}" = {
          image = "docker.io/library/redis:7";
          extraOptions = [ "--network=${network-name}" ];
        };

        "${names.containers.postgres}" = {
          image = "docker.io/library/postgres:16";
          environment = {
            "POSTGRES_DB" = "paperless";
            "POSTGRES_USER" = "paperless";
            "POSTGRES_PASSWORD" = "paperless";
          };
          extraOptions = [
            "--network=${network-name}"
            "--mount"
            "type=tmpfs,destination=/var/lib/postgresql/data/pg_stat_tmp"
          ];
          volumes = [
            "${paperless-paths.dbs}:/var/lib/postgresql/data"
          ];
        };
      };
    };
  };
}

