port: { username, pkgs, zpool-name, zpool-root, ip-addr, ... }:
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
in
{
  config = {
    systemd = {
      tmpfiles.settings = {
        postgres = utils.createDirs username [ postgres-path ];
        paperless = utils.createDirs username (builtins.attrValues paperless-paths);
      };

      services.create-paperless-network = {
        wantedBy = [ "podman-paperless.service" "podman-paperless-redis.service" "podman-paperless-postgres.service" ];
        serviceConfig = {
          ExecStart = "${pkgs.podman}/bin/podman network exists ${paperless-network-name} || ${pkgs.podman}/bin/podman network create ${paperless-network-name}";
        };
      };
    }
    //
    (utils.createSystemdZfsSnapshot pkgs "paperless" "${zpool-name}/paperless");

    virtualisation.oci-containers = {
      containers = {
        paperless = {
          image = "ghcr.io/paperless-ngx/paperless-ngx:latest";
          environment = {
            PAPERLESS_DBHOST = "paperless-postgres";
            PAPERLESS_REDIS = "redis://paperless-redis";
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
          extraOptions = [ "--network=${paperless-network-name}" ];
        };

        paperless-redis = {
          image = "docker.io/library/redis";
          extraOptions = [ "--network=${paperless-network-name}" ];
        };

        paperless-postgres = {
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

