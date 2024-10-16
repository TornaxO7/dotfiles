{ config, zpool-name, zpool-root, pkgs, lib, ... }:
let
  utils = import ../utils.nix;
  network-name = "joplin-network";
  username = config.users.users.main.name;

  names = utils.createContainerNames "joplin" [ "postgres" "server" ];

  db-path = "${zpool-root}/joplin";
in
{
  systemd = lib.attrsets.recursiveUpdate
    {
      tmpfiles.settings = {
        "${names.containers.postgres}" = utils.createDirs username [ db-path ];
      };

      services = {
        create-joplin-network = utils.createPodmanNetworkService pkgs network-name (builtins.attrValues names.service-full);

        "${names.service-prefixes.server}".requires = [ names.service-full.postgres ];
      };
    }
    (utils.createSystemdZfsSnapshot pkgs "joplin" "${zpool-name}/joplin");

  virtualisation.oci-containers.containers = {
    "${names.containers.postgres}" = {
      image = "postgres:16";

      environment = {
        "POSTGRES_PASSWORD" = "very-secret-password-rofl";
        "POSTGRES_USER" = "postgres";
        "POSTGRES_DB" = "joplin-db";
      };

      extraOptions = [
        "--network=${network-name}"
      ];

      volumes = [
        "${db-path}:/var/lib/postgresql/data"
      ];
    };

    "${names.containers.server}" = {
      image = "joplin/server:latest";

      environment = {
        "APP_PORT" = "22300";
        "APP_BASE_URL" = "http://joplin.local";
        "DB_CLIENT" = "pg";
        "POSTGRES_PASSWORD" = "very-secret-password-rofl";
        "POSTGRES_DATABASE" = "joplin-db";
        "POSTGRES_USER" = "postgres";
        "POSTGRES_PORT" = "5432";
        "POSTGRES_HOST" = "${names.containers.postgres}";
      };

      extraOptions = [
        "--network=${network-name}"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.${names.containers.server}.rule" = "Host(`joplin.local`)";
        "traefik.http.routers.${names.containers.server}.service" = names.containers.server;
        "traefik.http.services.${names.containers.server}.loadbalancer.server.port" = "22300";
      };
    };
  };
}
