{ config, lib, pkgs, zpool-name, zpool-root, ... }:
let
  utils = import ../utils.nix;
  username = config.users.users.main.name;

  paperless-dir = "${zpool-root}/paperless";

  postgres-path = "/var/lib/postgresql/data";
  paperless-paths = {
    data = "${paperless-dir}/data";
    media = "${paperless-dir}/media";
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
          "${names.containers.postgres}" = utils.createDirs username [ postgres-path ];
          "${names.containers.server}" = utils.createDirs username (builtins.attrValues paperless-paths);
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
            "traefik.http.routers.paperelss.rule" = "Host(`paperless.local`)";
            "traefik.http.routers.paperelss.service" = "paperelss";
            "traefik.http.services.paperelss.loadbalancer.server.port" = toString 8000;
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
          extraOptions = [ "--network=${network-name}" ];
          volumes = [
            "${postgres-path}:/var/lib/postgresql/data"
          ];
        };
      };
    };
  };
}

