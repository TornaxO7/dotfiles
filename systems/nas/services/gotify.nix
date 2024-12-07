utils: { config, zpool-root, domain-root, ... }:
let
  gotifyRoot = "${zpool-root}/gotify";
  domain = "gotify.${domain-root}";
in
{
  config = {
    virtualisation.oci-containers.containers.gotify = {
      image = "ghcr.io/gotify/server";
      volumes = [ "${gotifyRoot}:/app/data" ];
      environment = {
        TZ = config.time.timeZone;
      };

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.gotify.rule" = "Host(`${domain}`)";
        "traefik.http.routers.gotify.service" = "gotify";
        "traefik.http.services.gotify.loadbalancer.server.port" = "80";
      };
    };
  };
}
