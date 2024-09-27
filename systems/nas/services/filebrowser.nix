{ username, zpool-root, ... }:
let
  filebrowser-root = "${zpool-root}/filebrowser";
  database-path = "${filebrowser-root}/database.db";
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
        "traefik.http.routers.filebrowser.rule" = "Host(`filebrowser.local`)";
        "traefik.http.routers.filebrowser.service" = "filebrowser";
        "traefik.http.services.filebrowser.loadbalancer.server.port" = toString 80;
      };
    };
  };
}
