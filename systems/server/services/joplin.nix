{ config, services-root, pkgs, ... }:
let
  utils = import ./utils.nix;
  network-name = "joplin-network";
  domain = "joplin.tornaxo7.de";

  names = utils.createContainerNames "joplin" [ "postgres" "server" ];

  paths = rec {
    root = "${services-root}/joplin";
    db = "${root}/db";
  };
in
{
  systemd = {
    tmpfiles.settings.joplin = utils.createDirs config (builtins.attrValues paths);

    services = {
      create-joplin-network = utils.createPodmanNetworkService pkgs network-name (builtins.attrValues names.service-full);

      "${names.service-prefixes.server}".requires = [ names.service-full.postgres ];
    };
  };

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
        "${paths.db}:/var/lib/postgresql/data"
      ];
    };

    "${names.containers.server}" = {
      image = "joplin/server:latest";

      environment = {
        "APP_PORT" = "22300";
        "APP_BASE_URL" = "https://${domain}";
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
        "traefik.http.routers.${names.containers.server}.rule" = "Host(`${domain}`)";
        "traefik.http.routers.${names.containers.server}.service" = names.containers.server;
        "traefik.http.services.${names.containers.server}.loadbalancer.server.port" = "22300";
        "traefik.http.routers.${names.containers.server}.tls" = "true";
        "traefik.http.routers.${names.containers.server}.tls.certresolver" = "main";
      };
    };
  };
}
