{ config, services-root, ... }:
let
  utils = import ./utils.nix;
  domain = "gotify.tornaxo7.de";
  paths = rec {
    root = "${services-root}/gotify";
    config = "${root}/config";
  };
in
{
  config = {
    systemd.tmpfiles.settings = {
      gotify = utils.createDirs config (builtins.attrValues paths);
    };
    virtualisation.oci-containers.containers.gotify = {
      image = "ghcr.io/gotify/server";
      volumes = [
        "${paths.root}:/app/data"
        "${paths.config}:/etc/gotify"
      ];
      environment = {
        TZ = config.time.timeZone;
      };

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.gotify.rule" = "Host(`${domain}`)";
        "traefik.http.routers.gotify.service" = "gotify";
        "traefik.http.services.gotify.loadbalancer.server.port" = toString 80;
        "traefik.http.routers.gotify.tls" = "true";
        "traefik.http.routers.gotify.tls.certresolver" = "main";
      };
    };
  };
}
