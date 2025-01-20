{ lib, domain-root, ... }:
let
  prefix = "homarr";

  domain = "${prefix}.${domain-root}";

  volumes =
    let
      converter = (name: value: "${prefix}-value");
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
        "/var/run/podman/podman.sock:/var/run/docker.sock"

        "${volumes.config}:/app/data/configs"
        "${volumes.icons}:/app/public/icons"
        "${volumes.data}:/data"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.homarr.rule" = "Host(`${domain}`)";
        "traefik.http.routers.homarr.service" = "homarr";
        "traefik.http.services.homarr.loadbalancer.server.port" = toString 7575;
      };
    };

    dash = {
      image = "mauricenino/dashdot";

      volumes = [
        "/:/mnt/host:ro"
      ];

      extraOptions = [ "--privileged" ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.dash.rule" = "Host(`dash.${domain}`)";
        "traefik.http.routers.dash.service" = "dash";
        "traefik.http.services.dash.loadbalancer.server.port" = toString 3001;
      };
    };
  };
}
