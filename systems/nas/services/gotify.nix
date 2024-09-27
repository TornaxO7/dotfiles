{ config, zpool-root, ... }:
let
  gotifyRoot = "${zpool-root}/gotify";
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
        "traefik.http.routers.gotify.rule" = "Host(`gotify.local`)";
        "traefik.http.routers.gotify.service" = "gotify";
        "traefik.http.services.gotify.loadbalancer.server.port" = toString 80;
      };
    };
  };
}
