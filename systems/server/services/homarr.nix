{ config, services-root, ... }:
let
  utils = import ./utils.nix;
  domain = "dashboard.tornaxo7.de";

  paths = rec {
    root = "${services-root}/homarr";
    config = "${root}/configs";
    icons = "${root}/icons";
    data = "${root}/data";
  };
in
{
  systemd = {
    tmpfiles.settings.homarr-dirs = utils.createDirs config (builtins.attrValues paths);
  };

  virtualisation.oci-containers.containers = {
    homarr = {
      image = "ghcr.io/ajnart/homarr:latest";

      volumes = [
        "/var/run/podman/podman.sock:/var/run/docker.sock"

        "${paths.root}:/app/data/configs"
        "${paths.icons}:/app/public/icons"
        "${paths.data}:/data"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.homarr.rule" = "Host(`${domain}`)";
        "traefik.http.routers.homarr.service" = "homarr";
        "traefik.http.services.homarr.loadbalancer.server.port" = toString 7575;
        "traefik.http.routers.homarr.tls" = "true";
        "traefik.http.routers.homarr.tls.certresolver" = "main";
      };
    };
  };
}
