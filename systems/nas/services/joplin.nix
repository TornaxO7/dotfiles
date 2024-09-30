{ username, zpool-name, zpool-root, pkgs, lib, ... }:
let
  utils = import ../utils.nix;
  network-name = "joplin-network";

  container-names = utils.createContainerNames "joplin" [ "postgres" "server" ];
  service-prefixes = builtins.mapAttrs (name: value: "podman-${value}") container-names;
  service-full-names = builtins.mapAttrs (name: value: "${value}.service") service-prefixes;

  db-path = "${zpool-root}/joplin";
in
{
  systemd = lib.attrsets.recursiveUpdate
    {
      tmpfiles.settings = {
        "${container-names.postgres}" = utils.createDirs username [ db-path ];
      };

      services = {
        create-joplin-network = utils.createPodmanNetworkService pkgs network-name (builtins.attrValues service-full-names);

        "${service-prefixes.server}".requires = [ service-full-names.postgres ];
      };
    }
    (utils.createSystemdZfsSnapshot pkgs "joplin" "${zpool-name}/joplin");

  virtualisation.oci-containers.containers = {
    "${container-names.postgres}" = {
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

    "${container-names.server}" = {
      image = "joplin/server:latest";

      environment = {
        "APP_PORT" = "22300";
        "APP_BASE_URL" = "http://joplin.local";
        "DB_CLIENT" = "pg";
        "POSTGRES_PASSWORD" = "very-secret-password-rofl";
        "POSTGRES_DATABASE" = "joplin-db";
        "POSTGRES_USER" = "postgres";
        "POSTGRES_PORT" = "5432";
        "POSTGRES_HOST" = "${container-names.postgres}";
      };

      extraOptions = [
        "--network=${network-name}"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.${container-names.server}.rule" = "Host(`joplin.local`)";
        "traefik.http.routers.${container-names.server}.service" = container-names.server;
        "traefik.http.services.${container-names.server}.loadbalancer.server.port" = "22300";
      };
    };
  };
}
