{ config, lib, zpool-name, pkgs, zpool-root, ... }:
let
  utils = import ../utils.nix;
  username = config.users.users.main.name;

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

  immich-network-name = "immich-network";
in
{
  # inspiration taken from: https://github.com/notthebee/nix-config/blob/b95b1b004535d85fa45340e538a44847a039abef/containers/immich/default.nix
  config = {
    systemd = lib.attrsets.recursiveUpdate
      {
        tmpfiles.settings.immich = utils.createDirs username directories;

        services = {
          immich-network-creator = utils.createPodmanNetworkService pkgs immich-network-name [ "immich-redis.service" ];

          podman-immich = {
            requires = [ "podman-immich-postgres.service" ];
            after = [ "podman-immich-postgres.service" ];
          };
        };
      }
      (utils.createSystemdZfsSnapshot pkgs "immich" "${zpool-name}/immich");

    virtualisation.oci-containers.containers = {
      immich = {
        autoStart = true;
        image = "ghcr.io/imagegenius/immich:latest";
        environment = {
          PUID = "1000";
          PGID = "1000";
          TZ = "Etc/UTC";
          DB_HOSTNAME = "immich-postgres";
          DB_USERNAME = "postgres";
          DB_PASSWORD = "postgres";
          DB_DATABASE_NAME = "immich";

          REDIS_HOSTNAME = "immich-redis";
        };

        volumes = [
          "${immich-config}:/config"
          "${immich-photos}:/photos"
          "${immich-libraries}:/libraries"
        ];

        dependsOn = [ "immich-redis" "immich-postgres" ];
        extraOptions = [
          "--network=${immich-network-name}"
          "--device=/dev/dri:/dev/dri"
        ];

        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.immich.rule" = "Host(`immich.local`)";
          "traefik.http.routers.immich.service" = "immich";
          "traefik.http.services.immich.loadbalancer.server.port" = toString 8080;
        };
      };

      immich-redis = {
        autoStart = true;
        image = "redis";
        extraOptions = [ "--network=${immich-network-name}" ];
      };

      # using postgres
      immich-postgres = {
        autoStart = true;
        image = "tensorchord/pgvecto-rs:pg14-v0.2.0";
        environment = {
          POSTGRES_USER = "postgres";
          POSTGRES_PASSWORD = "postgres";
          POSTGRES_DB = "immich";
        };

        volumes = [
          "${immich-postgres-data}:/var/lib/postgresql/data"
        ];

        dependsOn = [ "immich-redis" ];
        extraOptions = [ "--network=${immich-network-name}" ];
      };
    };
  };
}
