utils: { config, services-root, domain-root, ... }:
let
  paths = rec {
    root = "${services-root}/filebrowser";
    database = "${root}/database";
    data = "${root}/data";
  };

  domain = "filebrowser.${domain-root}";
in
{
  systemd.tmpfiles.settings = {
    filbrowser-root = utils.createDirs config [ paths.root ];
    filebrowser = utils.createDirs config [ paths.data ];
    filebrowser-db.${paths.database}.f.user = config.users.users.main.name;
  };

  virtualisation.oci-containers.containers.filebrowser = {
    image = "filebrowser/filebrowser";
    volumes = [
      "${paths.data}:/srv"
      "${paths.database}:/database.db"
      "${paths.root}/settings.json:/config/settings.json"
    ];

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.filebrowser.rule" = "Host(`${domain}`)";
      "traefik.http.routers.filebrowser.service" = "filebrowser";
      "traefik.http.services.filebrowser.loadbalancer.server.port" = "80";
      "traefik.http.routers.filebrowser.tls" = "true";
      "traefik.http.routers.filebrowser.tls.certresolver" = "main";
    };
  };
}

