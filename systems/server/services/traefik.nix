{ config, services-root, ... }:
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
      "--entryPoints.https.asDefault=true"

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
      "${services-root}/acme:/etc/traefik/acme"
      "/etc/passwd:/etc/passwd:ro"
    ];
  };
}
