port: { username, pkgs, zpool-name, zpool-root, ip-addr, ... }:
let
  utils = import ../utils.nix;

  portStr = toString port;

  postgresPort = port + 1;
  postgresPortStr = toString postgresPort;

  redisPort = postgresPort + 1;
  redisPortStr = toString redisPort;

  paperless-dir = "${zpool-root}/paperless";

  postgres-path = "/var/lib/postgresql/data";
  paperless-paths = {
    data = "/var/lib/paperless/data";
    media = "${paperless-dir}/media";
    consume = "/var/lib/paperless/consume";
  };
in
{
  config = {
    systemd = {
      tmpfiles.settings = {
        postgres = utils.createDirs username [ postgres-path ];
        paperless = utils.createDirs username (builtins.attrValues paperless-paths);
      };
    }
    //
    (utils.createSystemdZfsSnapshot pkgs "paperless" "${zpool-name}/paperless");

    virtualisation.oci-containers = {
      containers = {
        paperless = {
          image = "ghcr.io/paperless-ngx/paperless-ngx:latest";
          environment = {
            PAPERLESS_DBHOST = "${ip-addr}";
            PAPERLESS_DBPORT = postgresPortStr;
            PAPERLESS_REDIS = "redis://${ip-addr}:${redisPortStr}";
          };
          ports = [ "${portStr}:8000" ];
          volumes = [
            "${paperless-paths.data}:/usr/src/paperless/data"
            "${paperless-paths.media}:/usr/src/paperless/media"
            "${paperless-paths.consume}:/usr/src/paperless/consume"
          ];
          dependsOn = [
            "paperless-postgres"
            "paperless-redis"
          ];
        };

        paperless-redis = {
          image = "docker.io/library/redis";
          ports = [ "${redisPortStr}:6379" ];
        };

        paperless-postgres = {
          image = "docker.io/library/postgres";
          environment = {
            "POSTGRES_DB" = "paperless";
            "POSTGRES_USER" = "paperless";
            "POSTGRES_PASSWORD" = "paperless";
          };
          ports = [ "${postgresPortStr}:5432" ];
          volumes = [
            "${postgres-path}:/var/lib/postgresql/data"
          ];
        };
      };
    };
  };
}
