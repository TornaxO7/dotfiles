utils: { config, zpool-root, domain-root, ... }:
let
  username = config.users.users.main.name;

  filebrowser-root = "${zpool-root}/filebrowser";
  database-path = "${filebrowser-root}/database.db";

  domain = "filebrowser.${domain-root}";
in
{
  config = {
    systemd.tmpfiles.settings.filebrowser.${database-path}.f.user = username;

    virtualisation.oci-containers.containers.filebrowser = {
      image = "filebrowser/filebrowser";
      volumes = [
        "${zpool-root}/syncthing:/srv"
        "${database-path}:/database.db"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.filebrowser.rule" = "Host(`${domain}`)";
        "traefik.http.routers.filebrowser.service" = "filebrowser";
        "traefik.http.services.filebrowser.loadbalancer.server.port" = "80";
      };
    };
  };
}
