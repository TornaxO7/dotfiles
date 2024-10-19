{ config, pkgs, services-root, ... }:
let
  utils = import ./utils.nix;
  domain = "vikunja.tornaxo7.de";

  network-name = "vikunja-network";

  names = utils.createContainerNames "vikunja" [ "server" "db" ];

  paths = rec {
    root = "${services-root}/vikunja";
    data = "${root}/files";
    db = "${root}/database";
  };
in
{
  systemd = {
    tmpfiles.settings.vikunja = utils.createDirs config (builtins.attrValues paths);

    services = {
      create-vikunja-network = utils.createPodmanNetworkService pkgs network-name (builtins.attrValues names.service-full);

      "${names.containers.server}" = rec {
        requires = [ names.service-full.db ];
        after = requires;
      };
    };
  };

  virtualisation.oci-containers.containers = {
    "${names.containers.server}" = {
      image = "vikunja/vikunja";
      environment = {
        VIKUNJA_SERVICE_PUBLICURL = "https://${domain}";
        VIKUNJA_DATABASE_HOST = "${names.containers.db}";
        VIKUNJA_DATABASE_PASSWORD = "password";
        VIKUNJA_DATABASE_TYPE = "mysql";
        VIKUNJA_DATABASE_USER = "vikunja";
        VIKUNJA_DATABASE_DATABASE = "vikunja";
        VIKUNJA_SERVICE_JWTSECRET = "<a super secure random secret>";
      };

      volumes = [ "${paths.data}:/app/vikunja/files" ];

      extraOptions = [ "--network=${network-name}" ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.vikunja.rule" = "Host(`${domain}`)";
        "traefik.http.routers.vikunja.service" = "vikunja";
        "traefik.http.services.vikunja.loadbalancer.server.port" = "3456";
        "traefik.http.routers.vikunja.tls" = "true";
        "traefik.http.routers.vikunja.tls.certresolver" = "main";
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
      volumes = [ "${paths.db}:/var/lib/mysql" ];
      extraOptions = [ "--network=${network-name}" ];
    };
  };
}
