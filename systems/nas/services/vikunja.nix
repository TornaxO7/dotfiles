{ lib, pkgs, username, zpool-root, zpool-name, ... }:
let
  utils = import ../utils.nix;

  network-name = "vikunja-network";

  vikunja-container-name = "vikunja";
  db-container-name = "vikunja-db";

  vikunja-service-name = "podman-${vikunja-container-name}.service";
  db-service-name = "podman-${db-container-name}.service";

  vikunja-root = "${zpool-root}/vikunja";
  vikunja-data-path = "${vikunja-root}/files";
  db-path = "${vikunja-root}/database";
in
{
  systemd = lib.attrsets.recursiveUpdate
    {
      tmpfiles.settings.vikunja = utils.createDirs username [ vikunja-data-path db-path ];

      services = {
        create-vikunja-network = utils.createPodmanNetworkService pkgs network-name [ vikunja-service-name db-service-name ];

        "${vikunja-container-name}" = {
          requires = [ db-service-name ];
          after = [ db-service-name ];
        };
      };
    }
    (utils.createSystemdZfsSnapshot pkgs "vikunja" "${zpool-name}/vikunja");

  virtualisation.oci-containers.containers = {
    "${vikunja-container-name}" = {
      image = "vikunja/vikunja";
      environment = {
        VIKUNJA_SERVICE_PUBLICURL = "http://vikunja.local/";
        VIKUNJA_DATABASE_HOST = "${db-container-name}";
        VIKUNJA_DATABASE_PASSWORD = "password";
        VIKUNJA_DATABASE_TYPE = "mysql";
        VIKUNJA_DATABASE_USER = "vikunja";
        VIKUNJA_DATABASE_DATABASE = "vikunja";
        VIKUNJA_SERVICE_JWTSECRET = "<a super secure random secret>";
      };

      dependsOn = [ "${db-container-name}" ];
      volumes = [ "${vikunja-data-path}:/app/vikunja/files" ];

      extraOptions = [ "--network=${network-name}" ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.vikunja.rule" = "Host(`vikunja.local`)";
        "traefik.http.routers.vikunja.service" = "vikunja";
        "traefik.http.services.vikunja.loadbalancer.server.port" = "3456";
      };
    };

    "${db-container-name}" = {
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
