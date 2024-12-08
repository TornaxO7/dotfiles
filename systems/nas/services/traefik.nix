{ config, domain-root, ... }:
let
  username = config.users.users.main.name;
  domain = "traefik.${domain-root}";
in
{
  virtualisation.oci-containers.containers.traefik = {
    image = "traefik:v3.1";
    cmd = [
      "--api=true"

      "--providers.docker=true"
      "--providers.docker.exposedbydefault=false"

      "--entryPoints.http.address=:80"
    ];

    extraOptions = [
      "--hostuser=${username}"
    ];

    ports = [
      "80:80"
    ];

    volumes = [
      "/var/run/podman/podman.sock:/var/run/docker.sock"
    ];

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.dashboard.rule" = "Host(`${domain}`)";
      "traefik.http.routers.dashboard.service" = "api@internal";
    };
  };
}
