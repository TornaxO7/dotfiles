{ config, ... }:
let
  username = config.users.users.main.name;
in
{
  virtualisation.oci-containers.containers.traefik = {
    image = "traefik:v3.1";
    cmd = [
      "--api.dashboard=false"
      "--providers.docker=true"
      "--providers.docker.exposedbydefault=false"

      "--entryPoints.http.address=:80"
      "--entryPoints.https.address=:443"
      "--certificatesresolvers.main.acme.email=tornax@tornaxo7.de"
      "--certificatesresolvers.main.acme.storage=acme.json"
      "--certificatesresolvers.main.acme.httpchallenge.entrypoint=http"
    ];

    extraOptions = [
      "--hostuser=${username}"
    ];

    ports = [
      "80:80"
      "443:443"
    ];

    volumes = [
      "/var/run/podman/podman.sock:/var/run/docker.sock"
    ];

    labels = {
      "traefik.http.routers.main-domain.rule" = "Host(`tornaxo7.de`)";
      "traefik.http.routers.main-domain.middlewares" = "main-domain@docker";
      "traefik.http.middlewares.main-domain.redirectregex.regex" = "^https?://tornaxo7\.de(/(.*))?";
      "traefik.http.middlewares.main-domain.redirectregex.replacement" = "https://blog.tornaxo7.de/$${1}";
    };
  };
}
