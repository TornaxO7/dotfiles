{ zpool-root, wg0, ... }:
let
  prefix = "filebrowser";

  domain = "${prefix}.${wg0.nas.host}";
in
{
  config = {
    virtualisation.oci-containers.containers.filebrowser = {
      image = "filebrowser/filebrowser";
      volumes = [
        "${zpool-root}/syncthing:/srv"
        "filebrowser-db:/database"
        "filebrowser-conf:/config"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.filebrowser.rule" = "Host(`${domain}`)";
        "traefik.http.routers.filebrowser.service" = "filebrowser";
        "traefik.http.services.filebrowser.loadbalancer.server.port" = "8080";
      };

      environment = {
        FB_PORT = "8080";
      };
    };
  };
}
