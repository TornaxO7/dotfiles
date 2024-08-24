port: { username, zpool-root, pkgs, ... }:
let
  utils = import ../utils.nix;
  portStr = toString port;

  gitea-service-name = "podman-gitea.service";
  gitea-db-service-name = "podman-gitea-database.service";

  gitea-root = "${zpool-root}/gitea";
  gitea-network-name = "gitea-network";

  ssh-port = port + 1;
  ssh-port-str = toString ssh-port;

  gitea-data-path = "${gitea-root}/data";
  database-path = "${gitea-root}/database";
in
{
  systemd = {
    tmpfiles.settings = {
      gitea-data = utils.createDirs username [ gitea-data-path ];
      database = utils.createDirs username [ database-path ];
    };

    services.create-gitea-network = utils.createPodmanNetworkService pkgs gitea-network-name [ gitea-service-name gitea-db-service-name ];
  };

  virtualisation.oci-containers.containers = {
    gitea = {
      image = "gitea/gitea:latest";
      volumes = [
        "${gitea-root}/data:/data"
        "/etc/localtime:/etc/localtime:ro"
      ];
      ports = [
        "${portStr}:3000"
        "${ssh-port-str}:22"
      ];
      environment = {
        GITEA__database__DB_TYPE = "mysql";
        GITEA__database__HOST = "gitea-database:3306";
        GITEA__database__NAME = "gitea";
        GITEA__database__USER = "gitea";
        GITEA__database__PASSWD = "gitea";
      };
      extraOptions = [ "--network=${gitea-network-name}" ];
      dependsOn = [ "gitea-database" ];
    };

    gitea-database = {
      image = "mysql:latest";
      environment = {
        MYSQL_ROOT_PASSWORD = "gitea";
        MYSQL_USER = "gitea";
        MYSQL_PASSWORD = "gitea";
        MYSQL_DATABASE = "gitea";
      };
      volumes = [
        "${database-path}:/var/lib/mysql"
      ];
      extraOptions = [ "--network=${gitea-network-name}" ];
    };
  };
}
