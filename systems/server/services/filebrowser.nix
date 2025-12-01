{ root-domain, ... }:
let
  prefix = "filebrowser";
  domain = "${prefix}.${root-domain}";
in
{
  virtualisation.oci-containers.containers.filebrowser = {
    image = "filebrowser/filebrowser";
    volumes = [
      "${prefix}-data:/srv"
      "${prefix}-settings:/config"
      "${prefix}-database:/database"
    ];

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.filebrowser.rule" = "Host(`${domain}`)";
      "traefik.http.routers.filebrowser.service" = "filebrowser";
      "traefik.http.routers.filebrowser.middlewares" = "authelia@file";
      "traefik.http.services.filebrowser.loadbalancer.server.port" = "8080";
    };

    environment = {
      FB_PORT = "8080";
    };
  };
}

