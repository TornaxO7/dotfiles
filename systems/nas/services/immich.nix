port: { username, zpool-root, ip-addr, ... }:
let
  utils = import ../utils.nix;
  portStr = toString port;

  redis-port = port + 1;
  redis-port-str = toString redis-port;

  postgres-port = redis-port + 1;
  postgres-port-str = toString postgres-port;

  immich-root = "${zpool-root}/immich";
  immich-config = "${immich-root}/config";
  immich-photos = "${immich-root}/photos";
  immich-libraries = "${immich-root}/libraries";
  immich-postgres = "${immich-root}/postgres";
  immich-postgres-data = "${immich-postgres}/data";

  directories = [
    immich-config
    immich-photos
    immich-libraries

    immich-postgres
    immich-postgres-data
  ];
in
{
  # inspiration taken from: https://github.com/notthebee/nix-config/blob/b95b1b004535d85fa45340e538a44847a039abef/containers/immich/default.nix
  config = {
    systemd.tmpfiles.settings.immich = utils.createDirs username directories;
    systemd.services = {
      podman-immich = {
        requires = [
          "podman-immich-redis.service"
          "podman-immich-postgres.service"
        ];
        after = [
          "podman-immich-redis.service"
          "podman-immich-postgres.service"
        ];
      };

      podman-immich-postgres = {
        requires = [ "podman-immich-redis.service" ];
        after = [ "podman-immich-redis.service" ];
      };
    };

    virtualisation.oci-containers.containers = {
      immich = {
        autoStart = true;
        image = "ghcr.io/imagegenius/immich:latest";
        ports = [ "${portStr}:8080" ];
        environment = {
          PUID = "1000";
          PGID = "1000";
          TZ = "Etc/UTC";
          DB_HOSTNAME = ip-addr;
          DB_USERNAME = "postgres";
          DB_PASSWORD = "postgres";
          DB_DATABASE_NAME = "immich";
          DB_PORT = postgres-port-str;

          REDIS_HOSTNAME = ip-addr;
          REDIS_PORT = redis-port-str;
        };

        volumes = [
          "${immich-config}:/config"
          "${immich-photos}:/photos"
          "${immich-libraries}:/libraries"
        ];
      };

      immich-redis = {
        autoStart = true;
        image = "redis";
        ports = [
          "${redis-port-str}:6379"
        ];
      };

      # using postgres
      immich-postgres = {
        autoStart = true;
        image = "tensorchord/pgvecto-rs:pg14-v0.2.0";
        ports = [
          "${postgres-port-str}:5432"
        ];
        environment = {
          POSTGRES_USER = "postgres";
          POSTGRES_PASSWORD = "postgres";
          POSTGRES_DB = "immich";
        };

        volumes = [
          "${immich-postgres-data}:/var/lib/postgresql/data"
        ];
      };
    };
  };
}
