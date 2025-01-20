utils: { config, services-root, domain-root, ... }:
let
  prefix = "filebrowser";
  domain = "${prefix}.${domain-root}";
in
{
  virtualisation.oci-containers.containers.filebrowser = {
    image = "filebrowser/filebrowser";
    volumes = [
      "${prefix}-data:/srv"
      "${prefix}-settings:/config"
      "${prefix}-database:/database"
    ];

    cmd = [ "--database=/database/database.db" ];

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.filebrowser.rule" = "Host(`${domain}`)";
      "traefik.http.routers.filebrowser.service" = "filebrowser";
      "traefik.http.services.filebrowser.loadbalancer.server.port" = "80";
    };
  };
}

