utils: { config, lib, pkgs, zpool-root, zpool-name, ... }:
let
  network-name = "vikunja-network";

  names = utils.createContainerNames "vikunja" [ "server" "db" ];

  vikunja-root = "${zpool-root}/vikunja";
  vikunja-data-path = "${vikunja-root}/files";
  db-path = "${vikunja-root}/database";
in
{
  systemd = lib.attrsets.recursiveUpdate
    {
      tmpfiles.settings.vikunja = utils.createDirs config [ vikunja-data-path db-path ];

      services = {
        create-vikunja-network = utils.createPodmanNetworkService pkgs network-name (builtins.attrValues names.service-full);

        "${names.containers.server}".requires = with names.service-full; [ db ];
      };
    }
    (utils.createSystemdZfsSnapshot pkgs "vikunja" "${zpool-name}/vikunja");

  virtualisation.oci-containers.containers = {
    "${names.containers.server}" = {
      image = "vikunja/vikunja";
      environment = {
        VIKUNJA_SERVICE_PUBLICURL = "http://vikunja.nas.local/";
        VIKUNJA_DATABASE_HOST = "${names.containers.db}";
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
        "traefik.http.routers.vikunja.rule" = "Host(`vikunja.nas.local`)";
        "traefik.http.routers.vikunja.service" = "vikunja";
        "traefik.http.services.vikunja.loadbalancer.server.port" = "3456";
      };
    };

    "${names.containers.db}" = {
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

