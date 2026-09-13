utils:
{ domain-root, ... }:
let
  domain = "whoami.${domain-root}";
in
{
  virtualisation.oci-containers.containers.whoami = {
    image = "traefik/whoami";
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.whoami.rule" = "Host(`${domain}`)";
      "traefik.http.routers.whoami.service" = "whoami";
      "traefik.http.services.whoami.loadbalancer.server.port" = "80";
    };
  };
}
