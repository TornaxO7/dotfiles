{ lib, pkgs, username, zpool-root, zpool-name, ... }:
let
  utils = import ../utils.nix;

  network-name = "vikunja-network";

  container-names = utils.createContainerNames "vikunja" [ "server" "db" ];
  service-prefixes = builtins.mapAttrs (name: value: "podman-${value}") container-names;
  service-full-names = builtins.mapAttrs (name: value: "${value}.service") service-prefixes;

  vikunja-root = "${zpool-root}/vikunja";
  vikunja-data-path = "${vikunja-root}/files";
  db-path = "${vikunja-root}/database";
in
{
  systemd = lib.attrsets.recursiveUpdate
    {
      tmpfiles.settings.vikunja = utils.createDirs username [ vikunja-data-path db-path ];

      services = {
        create-vikunja-network = utils.createPodmanNetworkService pkgs network-name (builtins.attrValues service-full-names);

        "${container-names.server}" = rec {
          requires = [ service-full-names.db ];
          after = requires;
        };
      };
    }
    (utils.createSystemdZfsSnapshot pkgs "vikunja" "${zpool-name}/vikunja");

  virtualisation.oci-containers.containers = {
    "${container-names.server}" = {
      image = "vikunja/vikunja";
      environment = {
        VIKUNJA_SERVICE_PUBLICURL = "http://vikunja.local/";
        VIKUNJA_DATABASE_HOST = "${container-names.db}";
        VIKUNJA_DATABASE_PASSWORD = "password";
        VIKUNJA_DATABASE_TYPE = "mysql";
        VIKUNJA_DATABASE_USER = "vikunja";
        VIKUNJA_DATABASE_DATABASE = "vikunja";
        VIKUNJA_SERVICE_JWTSECRET = "<a super secure random secret>";
      };

      volumes = [ "${vikunja-data-path}:/app/vikunja/files" ];

      extraOptions = [ "--network=${network-name}" ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.vikunja.rule" = "Host(`vikunja.local`)";
        "traefik.http.routers.vikunja.service" = container-names.server;
        "traefik.http.services.vikunja.loadbalancer.server.port" = "3456";
      };
    };

    "${container-names.db}" = {
      image = "mariadb:latest";
      cmd = [ "--character-set-server=utf8mb4" "--collation-server=utf8mb4_unicode_ci" ];
      environment = {
        MYSQL_ROOT_PASSWORD = "supersecret";
        MYSQL_USER = "vikunja";
        MYSQL_PASSWORD = "password";
        MYSQL_DATABASE = "vikunja";
      };
      volumes = [ "${db-path}:/var/lib/mysql" ];
      extraOptions = [ "--network=${network-name}" ];
    };
  };
}
