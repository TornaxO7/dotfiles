utils: { config, pkgs, lib, zpool-root, domain-root, services-root, ... }:
let
  # ZFS
  bind-root = "${zpool-root}/immich";

  binds = {
    images = bind-root;
  };

  volumes = {
    ml-cache = "immich-model-cache";
    db = "immich-db";
  };

  names = utils.createContainerNames "immich" [ "server" "ml" "redis" "db" ];

  domain = "immich.${domain-root}";
  network-name = "immich-network";

  env = {
    UPLOAD_LOCATION = binds.images;
    TZ = "Europe/Berlin";
    IMMICH_VERSION = "release";
    DB_PASSWORD = "a very good one";
    DB_USERNAME = "immich";
    DB_DATABASE_NAME = "immich";
  };
in
{
  systemd.services = {
    create-immich-network = utils.createPodmanNetworkService pkgs network-name (builtins.attrValues names.service-full);
  };

  virtualisation.oci-containers.containers = {
    ${names.containers.server} = {
      image = "ghcr.io/immich-app/immich-server:release";
      user = config.users.users.main.name;
      volumes = [
        "${binds.images}:/usr/src/app/upload"
        "/etc/localtime:/etc/localtime:ro"
        "/etc/passwd:/etc/passwd:ro"
      ];

      environment = env // {
        DB_HOSTNAME = names.containers.db;
        REDIS_HOSTNAME = names.containers.redis;
      };

      dependsOn = with names.containers; [ redis db ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.${names.containers.server}.rule" = "Host(`${domain}`)";
        "traefik.http.routers.${names.containers.server}.service" = "${names.containers.server}";
        "traefik.http.services.${names.containers.server}.loadbalancer.server.port" = "2283";
      };

      extraOptions = [ "--network=${network-name}" ];
    };

    ${names.containers.ml} = {
      image = "ghcr.io/immich-app/immich-machine-learning:release";
      volumes = [
        "${volumes.ml-cache}:/cache"
      ];
      environment = env;
      extraOptions = [ "--network=${network-name}" ];
    };

    ${names.containers.redis} = {
      image = "docker.io/redis:6.2-alpine@sha256:eaba718fecd1196d88533de7ba49bf903ad33664a92debb24660a922ecd9cac8";
      extraOptions = [ "--network=${network-name}" ];
    };

    ${names.containers.db} = {
      image = "docker.io/tensorchord/pgvecto-rs:pg14-v0.2.0@sha256:90724186f0a3517cf6914295b5ab410db9ce23190a2d9d0b9dd6463e3fa298f0";

      environment = env // {
        POSTGRES_PASSWORD = env.DB_PASSWORD;
        POSTGRES_USER = env.DB_USERNAME;
        POSTGRES_DB = env.DB_DATABASE_NAME;
        POSTGRES_INITDB_ARGS = "--data-checksums";
      };

      volumes = [
        "${volumes.db}:/var/lib/postgresql/data"
      ];
      extraOptions = [ "--network=${network-name}" ];

      cmd = [
        "postgres"
        "-cshared_preload_libraries=vectors.so"
        "-csearch_path='\"$$user\", public, vectors'"
        "-clogging_collector=on"
        "-cmax_wal_size=2GB"
        "-cshared_buffers=512MB"
        "-cwal_compression=on"
      ];
    };
  };
}
