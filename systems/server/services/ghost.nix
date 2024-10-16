{ config, services-root, pkgs, ... }:
let
  utils = import ./utils.nix;
  network-name = "ghost-network";

  paths = rec {
    root = "${services-root}/ghost";
    ghost-content = "${root}/ghost-content";
    ghost-db = "${root}/ghost-db";
  };

  names = utils.createContainerNames "ghost" [ "ghost" "db" ];
in
{
  systemd = {
    tmpfiles.settings = {
      "${paths.root}" = utils.createDirs config [ paths.root ];
      "ghost-dirs" = utils.createDirs config (with paths; [ ghost-content ghost-db ]);
    };

    services = {
      create-ghost-network = utils.createPodmanNetworkService pkgs network-name (builtins.attrValues names.service-full);

      "${names.service-prefixes.ghost}".requires = with names.service-full; [ db ];
    };
  };

  virtualisation.oci-containers.containers = {
    "${names.containers.ghost}" = {
      image = "ghost:5-alpine";
      volumes = [
        "${paths.ghost-content}:/var/lib/ghost/content"
      ];
      environment = {
        url = "https://ghost.tornaxo7.de";

        database__client = "mysql";
        database__connection__host = "${names.containers.db}";
        database__connection__user = "root";
        database__connection__password = "very secret, I know";
        database__connection__database = "ghost";
      };
      extraOptions = [ "--network=${network-name}" ];
      labels = {
        "traefik.enable" = "true";
        "traefik.https.routers.ghost.rule" = "Host(`ghost.tornaxo7.de`)";
        "traefik.https.routers.ghost.service" = names.containers.db;
        "traefik.https.services.ghost.loadbalancer.server.port" = "2368";
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
