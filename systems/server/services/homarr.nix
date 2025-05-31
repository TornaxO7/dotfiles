{ lib, domain-root, ... }:
let
  prefix = "homarr";

  domain = "${prefix}.${domain-root}";

  volumes =
    let
      converter = name: value: "${prefix}-${value}";
    in
    lib.attrsets.mapAttrs converter {
      config = "config";
      icons = "icons";
      data = "data";
    };
in
{
  virtualisation.oci-containers.containers = {
    homarr = {
      image = "ghcr.io/ajnart/homarr:latest";

      volumes = [
        "${volumes.config}:/app/data/configs"
        "${volumes.icons}:/app/public/icons"
        "${volumes.data}:/data"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.${prefix}.rule" = "Host(`${domain}`)";
        "traefik.http.routers.${prefix}.service" = "${prefix}";
        "traefik.http.routers.${prefix}.middlewares" = "authelia@file";
        "traefik.http.services.${prefix}.loadbalancer.server.port" = "7575";
      };
    };
  };
}
