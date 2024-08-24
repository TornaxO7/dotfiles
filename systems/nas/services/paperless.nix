port: { lib, username, pkgs, zpool-name, zpool-root, ip-addr, ... }:
let
  utils = import ../utils.nix;

  portStr = toString port;

  paperless-dir = "${zpool-root}/paperless";

  postgres-path = "/var/lib/postgresql/data";
  paperless-paths = {
    data = "/var/lib/paperless/data";
    media = "${paperless-dir}/media";
    consume = "/var/lib/paperless/consume";
  };

  paperless-network-name = "paperless-network";

  # service names
  postgres-container-name = "paperless-postgres";
  redis-container-name = "paperless-redis";

  paperless-service = "podman-paperless.service";
  postgres-service = "podman-${postgres-container-name}.service";
  redis-service = "podman-${redis-container-name}.service";
in
{
  config = {
    systemd = lib.attrsets.recursiveUpdate
      {
        tmpfiles.settings = {
          postgres = utils.createDirs username [ postgres-path ];
          paperless = utils.createDirs username (builtins.attrValues paperless-paths);
        };

        services = {
          create-paperless-network = utils.createPodmanNetworkService pkgs paperless-network-name [ paperless-service postgres-service redis-service ];

          # make sure that whenever a service gets restarted, everything gets correctly restarted
          podman-paperless = {
            requires = [ postgres-service redis-service ];
            after = [ postgres-service redis-service ];
          };
          podman-postgres = {
            requires = [ redis-service ];
            after = [ redis-service ];
          };
        };
      }
      (utils.createSystemdZfsSnapshot pkgs "paperless" "${zpool-name}/paperless");


    virtualisation.oci-containers = {
      containers = {
        paperless = {
          image = "ghcr.io/paperless-ngx/paperless-ngx:latest";
          environment = {
            PAPERLESS_DBHOST = "${postgres-container-name}";
            PAPERLESS_REDIS = "redis://${redis-container-name}:6379";
          };
          ports = [ "${portStr}:8000" ];
          volumes = [
            "${paperless-paths.data}:/usr/src/paperless/data"
            "${paperless-paths.media}:/usr/src/paperless/media"
            "${paperless-paths.consume}:/usr/src/paperless/consume"
          ];
          dependsOn = [
            "${postgres-container-name}"
            "${redis-container-name}"
          ];
          extraOptions = [ "--network=${paperless-network-name}" ];
        };

        "${redis-container-name}" = {
          image = "docker.io/library/redis";
          extraOptions = [ "--network=${paperless-network-name}" ];
        };

        "${postgres-container-name}" = {
          image = "docker.io/library/postgres";
          environment = {
            "POSTGRES_DB" = "paperless";
            "POSTGRES_USER" = "paperless";
            "POSTGRES_PASSWORD" = "paperless";
          };
          extraOptions = [ "--network=${paperless-network-name}" ];
          volumes = [
            "${postgres-path}:/var/lib/postgresql/data"
          ];
        };
      };
    };
  };
}

