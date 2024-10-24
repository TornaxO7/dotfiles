{ config, services-root, pkgs, ... }:
let
  utils = import ./utils.nix;
  network-name = "ghost-network";

  paths = rec {
    root = "${services-root}/ghost";
    ghost-content = "${root}/ghost-content";
    ghost-db = "${root}/ghost-db";
  };

  names = utils.createContainerNames "ghost" [ "server" "db" ];
in
{
  systemd = {
    tmpfiles.settings = {
      "${paths.root}" = utils.createDirs config [ paths.root ];
      "ghost-dirs" = utils.createDirs config (with paths; [ ghost-content ghost-db ]);
    };

    services = {
      create-ghost-network = utils.createPodmanNetworkService pkgs network-name (builtins.attrValues names.service-full);

      "${names.service-prefixes.server}".requires = with names.service-full; [ db ];
    };
  };

  virtualisation.oci-containers.containers = {
    "${names.containers.server}" = {
      image = "ghost:5-alpine";
      volumes = [
        "${paths.ghost-content}:/var/lib/ghost/content"
      ];
      environment = {
        url = "https://blog.tornaxo7.de";

        database__client = "mysql";
        database__connection__host = names.containers.db;
        database__connection__user = "root";
        database__connection__password = "very secret, I know";
        database__connection__database = "ghost";
      };
      extraOptions = [ "--network=${network-name}" ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.ghost.rule" = "Host(`blog.tornaxo7.de`)";
        "traefik.http.routers.ghost.service" = names.containers.server;
        "traefik.http.routers.ghost.tls" = "true";
        "traefik.http.routers.ghost.tls.certresolver" = "main";
        "traefik.http.services.${names.containers.server}.loadbalancer.server.port" = "2368";
      };
    };

    "${names.containers.db}" = {
      image = "mysql:8.0";
      volumes = [
        "${paths.ghost-db}:/var/lib/mysql"
      ];
      environment = {
        MYSQL_ROOT_PASSWORD = "very secret, I know";
      };
      extraOptions = [ "--network=${network-name}" ];
    };
  };
}
