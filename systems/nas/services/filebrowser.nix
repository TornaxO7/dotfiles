utils: { config, zpool-root, domain-root, services-root, ... }:
let
  prefix = "filebrowser";

  paths = rec {
    root = "${services-root}/${prefix}";
    db = "${root}/database.db";
  };

  domain = "${prefix}.${domain-root}";
in
{
  config = {
    systemd.tmpfiles = {
      rules = [
        "d ${paths.root} 0744 - - - -"
        "f+ ${paths.db} 0644 tornax - - -"
      ];
    };

    virtualisation.oci-containers.containers.filebrowser = {
      image = "filebrowser/filebrowser";
      volumes = [
        "${zpool-root}/syncthing:/srv"
        "${paths.db}:/database.db"
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
