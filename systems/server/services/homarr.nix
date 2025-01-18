utils: { config, services-root, domain-root, ... }:
let
  domain = "dashboard.${domain-root}";

  vol-prefix = "homarr";
in
{
  virtualisation.oci-containers.containers = {
    homarr = {
      image = "ghcr.io/ajnart/homarr:latest";

      volumes = [
        "/var/run/podman/podman.sock:/var/run/docker.sock"

        "${vol-prefix}-configs:/app/data/configs"
        "${vol-prefix}-icons:/app/public/icons"
        "${vol-prefix}-data:/data"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.homarr.rule" = "Host(`${domain}`)";
        "traefik.http.routers.homarr.service" = "homarr";
        "traefik.http.services.homarr.loadbalancer.server.port" = "7575";
        "traefik.http.routers.homarr.tls" = "true";
        "traefik.http.routers.homarr.tls.certresolver" = "main";
      };
    };
  };
}
