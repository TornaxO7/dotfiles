{ config, wg, ... }:
let
  prefix = "homarr";

  domain = "${prefix}.${wg.server.host}";

  volume-name = "homarr";
in
{
  age.secrets.homarr.file = ../../../secrets/homarr.age;

  virtualisation.oci-containers.containers = {
    homarr = {
      image = "ghcr.io/homarr-labs/homarr:latest";

      volumes = [
        "${volume-name}:/appdata"
      ];

      environmentFiles = [
        config.age.secrets.homarr.path
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.${prefix}.rule" = "Host(`${domain}`)";
        "traefik.http.routers.${prefix}.entrypoints" = "http-vpn";
        "traefik.http.routers.${prefix}.service" = "${prefix}";
        "traefik.http.services.${prefix}.loadbalancer.server.port" = "7575";
      };
    };
  };
}
